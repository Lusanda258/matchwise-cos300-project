import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const SubmitRatingSchema = z.object({
  match_id: z.string().uuid(),
  provider_id: z.string().uuid(),
  rating: z.number().min(1).max(5),
  comment: z.string().optional(),
});

export const submitRating = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => SubmitRatingSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Verify the match exists and belongs to this user as a client
    const { data: match, error: matchErr } = await supabase
      .from("matches")
      .select(`
        id,
        provider_id,
        inquiry_status,
        service_request:service_requests(client_id)
      `)
      .eq("id", data.match_id)
      .single();

    if (matchErr || !match) throw new Error("Match not found");

    // Verify the user is the client for this match
    if (match.service_request?.client_id !== userId) {
      throw new Error("Not authorized to rate this provider");
    }

    // Verify the match is completed
    if (match.inquiry_status !== "completed") {
      throw new Error("Can only rate completed jobs");
    }

    // Check if user already rated this provider for this match
    const { data: existingRating } = await supabase
      .from("ratings")
      .select("*")
      .eq("client_id", userId)
      .eq("provider_id", data.provider_id)
      .single();

    if (existingRating) {
      throw new Error("You have already rated this provider");
    }

    // Insert the rating
    const { error: ratingErr } = await supabase
      .from("ratings")
      .insert({
        client_id: userId,
        provider_id: data.provider_id,
        rating: data.rating,
        comment: data.comment || null,
      });

    if (ratingErr) throw new Error(ratingErr.message);

    // Update provider's average rating
    try {
      const { data: ratings } = await supabaseAdmin
        .from("ratings")
        .select("rating")
        .eq("provider_id", data.provider_id);

      if (ratings && ratings.length > 0) {
        const totalRating = ratings.reduce((sum, r) => sum + r.rating, 0);
        const avgRating = totalRating / ratings.length;

        await supabaseAdmin
          .from("service_providers")
          .update({
            avg_rating: avgRating,
            rating_count: ratings.length,
          })
          .eq("id", data.provider_id);
      }
    } catch (error) {
      // Don't fail the rating if updating the average fails
      console.error("Failed to update provider average rating:", error);
    }

    // Create notification for provider (non-blocking)
    try {
      await supabaseAdmin.rpc("create_notification", {
        p_user_id: match.provider_id,
        p_type: "success",
        p_title: "New Rating Received",
        p_message: `You received a ${data.rating}-star rating from a client.`,
        p_metadata: { match_id: data.match_id, rating: data.rating },
      });
    } catch (error) {
      console.error("Failed to create notification:", error);
    }

    return { success: true };
  });
