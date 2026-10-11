import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const CreateNotificationSchema = z.object({
  user_id: z.string().uuid().optional(), // Optional - if not provided, will be derived from match_id
  type: z.enum(["success", "error", "warning", "info"]),
  title: z.string().min(1).max(200),
  message: z.string().min(1).max(1000),
  metadata: z.record(z.any()).optional(),
  match_id: z.string().uuid().optional(), // Optional - used to derive recipient
});

export const createServerNotification = createServerFn({ method: "POST" })
  .inputValidator((input: unknown) => CreateNotificationSchema.parse(input))
  .handler(async ({ data }) => {
    // Get the current user from the request context if available
    let userId: string | null = null;
    try {
      const { data: { user } } = await supabaseAdmin.auth.getUser();
      userId = user?.id || null;
    } catch (error) {
      console.log("Could not get current user, proceeding without userId check");
    }

    console.log("Creating server notification:", data, "Current user:", userId);

    // If user_id is not provided but match_id is, derive the recipient
    let recipientId = data.user_id;
    
    if (!recipientId && data.match_id) {
      console.log("Deriving recipient from match_id:", data.match_id);
      
      // Get the match details to determine the recipient
      const { data: match, error: matchError } = await supabaseAdmin
        .from("matches")
        .select("request_id, provider_id")
        .eq("id", data.match_id)
        .single();

      if (matchError) {
        console.error("Failed to get match:", matchError);
        throw new Error(`Failed to get match: ${matchError.message}`);
      }

      if (!match) {
        console.error("Match not found");
        throw new Error("Match not found");
      }

      // Get the service request to find the client_id
      const { data: serviceRequest, error: serviceRequestError } = await supabaseAdmin
        .from("service_requests")
        .select("client_id")
        .eq("id", match.request_id)
        .single();

      if (serviceRequestError) {
        console.error("Failed to get service request:", serviceRequestError);
        throw new Error(`Failed to get service request: ${serviceRequestError.message}`);
      }

      // Get the provider's user_id
      const { data: provider, error: providerError } = await supabaseAdmin
        .from("service_providers")
        .select("user_id")
        .eq("id", match.provider_id)
        .single();

      if (providerError) {
        console.error("Failed to get provider:", providerError);
        throw new Error(`Failed to get provider: ${providerError.message}`);
      }

      // Determine recipient: if current user is the provider, notify the client; otherwise notify the provider
      if (userId && userId === provider?.user_id) {
        recipientId = serviceRequest?.client_id;
        console.log("Current user is provider, notifying client:", recipientId);
      } else {
        recipientId = provider?.user_id;
        console.log("Current user is client or unknown, notifying provider:", recipientId);
      }
    }

    if (!recipientId) {
      console.error("Could not determine recipient");
      throw new Error("Could not determine notification recipient");
    }

    // Only allow creating notifications for other users (not self) - skip if userId is unknown
    if (userId && recipientId === userId) {
      console.log("Attempted to create notification for self, skipping");
      return { success: true }; // Don't throw, just skip silently
    }

    const { error } = await supabaseAdmin.rpc("create_notification", {
      p_user_id: recipientId,
      p_type: data.type,
      p_title: data.title,
      p_message: data.message,
      p_metadata: data.metadata || {},
    });

    if (error) {
      console.error("Failed to create notification:", error);
      throw new Error(`Failed to create notification: ${error.message}`);
    }

    console.log("Notification created successfully for:", recipientId);
    return { success: true };
  });