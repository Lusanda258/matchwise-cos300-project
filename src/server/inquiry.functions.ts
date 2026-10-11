import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const RequestProviderSchema = z.object({
  match_id: z.string().uuid(),
  message: z.string().min(10).max(1000),
  preferred_date: z.string().optional().nullable(),
});

const RespondInquirySchema = z.object({
  match_id: z.string().uuid(),
  action: z.enum(["accepted", "declined", "completed", "cancelled"]),
});

export const requestProvider = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => RequestProviderSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: match, error: matchErr } = await supabase
      .from("matches")
      .select("id, request_id, inquiry_status")
      .eq("id", data.match_id)
      .single();

    if (matchErr || !match) throw new Error("Match not found");

    const { data: request } = await supabase
      .from("service_requests")
      .select("client_id")
      .eq("id", match.request_id)
      .single();

    if (!request || request.client_id !== userId) throw new Error("Not authorized");

    if (match.inquiry_status !== "none") {
      throw new Error("You have already sent a request for this provider");
    }

    const { error: updateErr } = await supabase
      .from("matches")
      .update({
        inquiry_status: "requested",
        inquiry_message: data.message,
        inquiry_preferred_date: data.preferred_date ?? null,
        inquiry_requested_at: new Date().toISOString(),
      })
      .eq("id", data.match_id);

    if (updateErr) throw new Error(updateErr.message);

    await supabase
      .from("service_requests")
      .update({ status: "in_progress" })
      .eq("id", match.request_id);

    // Create notification for provider (non-blocking)
    try {
      const { data: provider } = await supabaseAdmin
        .from("service_providers")
        .select("user_id")
        .eq("id", match.provider_id)
        .single();

      if (provider) {
        await supabaseAdmin.rpc("create_match_notification", {
          p_match_id: data.match_id,
          p_type: "info",
          p_title: "New Service Request",
          p_message: "You have received a new service request. Check your dashboard to respond.",
          p_metadata: { match_id: data.match_id },
          p_sender_id: userId
        });
      }
    } catch (error) {
      // Notification failure shouldn't block the request
      console.error("Failed to create notification:", error);
    }

    return { success: true };
  });

export const respondToInquiry = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => RespondInquirySchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: match, error: matchErr } = await supabase
      .from("matches")
      .select("id, provider_id, inquiry_status, request_id")
      .eq("id", data.match_id)
      .single();

    if (matchErr || !match) throw new Error("Match not found");

    const { data: provider } = await supabase
      .from("service_providers")
      .select("user_id, business_name")
      .eq("id", match.provider_id)
      .single();

    if (!provider || provider.user_id !== userId) throw new Error("Not authorized");

    // Validate status transitions
    if (data.action === "accepted" || data.action === "declined") {
      if (match.inquiry_status !== "requested") {
        throw new Error("This inquiry is no longer pending");
      }
    } else if (data.action === "completed" || data.action === "cancelled") {
      if (match.inquiry_status !== "accepted") {
        throw new Error("This request must be accepted before it can be completed or cancelled");
      }
    }

    const { error: updateErr } = await supabase
      .from("matches")
      .update({ inquiry_status: data.action })
      .eq("id", data.match_id);

    if (updateErr) throw new Error(updateErr.message);

    // Create notification for client based on action (non-blocking)
    try {
      const { data: request } = await supabaseAdmin
        .from("service_requests")
        .select("client_id")
        .eq("id", match.request_id)
        .single();

      if (request) {
        let notificationType: "success" | "error" | "warning" | "info" = "info";
        let notificationTitle = "";
        let notificationMessage = "";

        switch (data.action) {
          case "accepted":
            notificationType = "success";
            notificationTitle = "Request Accepted!";
            notificationMessage = `${provider.business_name} has accepted your service request. You can now start chatting.`;
            break;
          case "declined":
            notificationType = "warning";
            notificationTitle = "Request Declined";
            notificationMessage = `${provider.business_name} has declined your service request.`;
            break;
          case "completed":
            notificationType = "success";
            notificationTitle = "Service Completed";
            notificationMessage = `${provider.business_name} has marked this service as completed.`;
            break;
          case "cancelled":
            notificationType = "error";
            notificationTitle = "Service Cancelled";
            notificationMessage = `${provider.business_name} has cancelled this service request.`;
            break;
        }

        await supabaseAdmin.rpc("create_match_notification", {
          p_match_id: data.match_id,
          p_type: notificationType,
          p_title: notificationTitle,
          p_message: notificationMessage,
          p_metadata: { match_id: data.match_id, provider_id: match.provider_id },
          p_sender_id: userId
        });
      }
    } catch (error) {
      // Notification failure shouldn't block the request
      console.error("Failed to create notification:", error);
    }

    return { success: true, status: data.action };
  });

const GetMatchHistorySchema = z.object({
  provider_id: z.string().uuid(),
});

export const getMatchHistoryWithProvider = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => GetMatchHistorySchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Get previous matches between this client and provider
    const { data: matches, error: matchErr } = await supabase
      .from("matches")
      .select(`
        id,
        inquiry_status,
        service_requests (
          id,
          request_text,
          location,
          created_at
        )
      `)
      .eq("provider_id", data.provider_id)
      .eq("service_requests.client_id", userId)
      .order("created_at", { ascending: false })
      .limit(5);

    if (matchErr) throw new Error("Failed to fetch match history");

    // Extract unique locations and recent request texts
    const locations = new Set<string>();
    const recentRequests: string[] = [];

    matches?.forEach((match: any) => {
      if (match.service_requests?.location) {
        locations.add(match.service_requests.location);
      }
      if (match.service_requests?.request_text && recentRequests.length < 3) {
        recentRequests.push(match.service_requests.request_text);
      }
    });

    return {
      locations: Array.from(locations),
      recentRequests,
      hasHistory: (matches?.length || 0) > 0,
    };
  });

const CreateMatchForFavoriteSchema = z.object({
  provider_id: z.string().uuid(),
  request_text: z.string().min(10).max(2000),
  location: z.string().optional().nullable(),
});

export const createMatchForFavorite = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => CreateMatchForFavoriteSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Verify the provider exists
    const { data: provider, error: providerErr } = await supabase
      .from("service_providers")
      .select("id")
      .eq("id", data.provider_id)
      .single();

    if (providerErr || !provider) {
      console.error("Provider not found:", providerErr);
      throw new Error("Provider not found");
    }

    // Create a new service request
    const { data: serviceRequest, error: requestErr } = await supabase
      .from("service_requests")
      .insert({
        client_id: userId,
        request_text: data.request_text,
        location: data.location || null,
        status: "matched",
      })
      .select()
      .single();

    if (requestErr || !serviceRequest) {
      console.error("Failed to create service request:", requestErr);
      throw new Error("Failed to create service request");
    }

    // Create a match record for the favorite provider using supabaseAdmin to bypass RLS
    const { data: match, error: matchErr } = await supabaseAdmin
      .from("matches")
      .insert({
        request_id: serviceRequest.id,
        provider_id: data.provider_id,
        score: 100, // High score for manually selected favorites
        reason: "Direct request from favorite providers",
        inquiry_status: "none",
      })
      .select()
      .single();

    if (matchErr || !match) {
      console.error("Failed to create match:", matchErr);
      throw new Error(`Failed to create match: ${matchErr?.message || "Unknown error"}`);
    }

    return { success: true, match_id: match.id };
  });
