import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";
import { matchProviders } from "./matchModel";

const RequestSchema = z.object({
  request_text: z.string().min(10).max(2000),
  location: z.string().max(120).optional().nullable(),
});

interface AIMatchResult {
  service_type: string;
  keywords: string[];
  summary: string;
  ranked: { provider_id: string; score: number; reason: string }[];
}

export const matchRequest = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => RequestSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // 1. Insert request
    const { data: request, error: reqErr } = await supabase
      .from("service_requests")
      .insert({
        client_id: userId,
        request_text: data.request_text,
        location: data.location ?? null,
      })
      .select()
      .single();

    if (reqErr || !request)
      throw new Error(reqErr?.message ?? "Failed to create request");


    // 2. Pull verified providers
    const { data: providers, error: providerError } = await supabaseAdmin
      .from("service_providers")
      .select(
        "id, business_name, category, bio, location, hourly_rate, avg_rating, rating_count, status, verification_status"
      )
      .eq("verification_status", "verified");

    if (providerError) {
      throw new Error(`Failed to fetch providers: ${providerError.message}`);
    }


    const providerList = providers ?? [];

    if (providerList.length === 0) {
      await supabase
        .from("service_requests")
        .update({
          status: "no match",
          ai_summary: "No verified providers available yet.",
          ai_keywords: [],
        })
        .eq("id", request.id);

      return {
        request_id: request.id,
        matches: [],
      };
    }


    // 3. Local ML model matching
    const result = matchProviders(
      data.request_text,
      data.location,
      providerList
    );

    // 4. Save matches
    const validIds = new Set(providerList.map(p => p.id));

    const cleanRanked = result.ranked
      .filter(r => validIds.has(r.provider_id))
      .slice(0, 5);

    // Filter out matches with 0% score
    const validMatches = cleanRanked.filter(r => r.score > 0);

    let savedMatches: { id: string; provider_id: string; score: number; reason: string | null }[] = [];

    if (validMatches.length) {
      const { data: inserted, error: insertError } = await supabaseAdmin
        .from("matches")
        .insert(
          validMatches.map(r => ({
            request_id: request.id,
            provider_id: r.provider_id,
            score: Math.max(
              0,
              Math.min(100, r.score)
            ),
            reason: r.reason,
          }))
        )
        .select("id, provider_id, score, reason");

      if (insertError) {
        throw new Error(`Failed to save matches: ${insertError.message}`);
      }

      savedMatches = inserted ?? [];
    }

    // Set status based on whether there are valid matches
    const requestStatus = validMatches.length > 0 ? "matched" : "no match";

    await supabase
      .from("service_requests")
      .update({
        status: requestStatus,
        service_type: result.service_type,
        ai_summary: result.summary,
        ai_keywords: result.keywords,
      })
      .eq("id", request.id);



    // 5. Return results
    const enriched = validMatches.map(r => {
      const p = providerList.find(
        pp => pp.id === r.provider_id
      )!;
      const saved = savedMatches.find(m => m.provider_id === r.provider_id);

      return {
        ...r,
        match_id: saved?.id ?? "",
        provider: p,
      };
    });


    return {
      request_id: request.id,
      summary: result.summary,
      service_type: result.service_type,
      keywords: result.keywords,
      matches: enriched,
    };
  });
