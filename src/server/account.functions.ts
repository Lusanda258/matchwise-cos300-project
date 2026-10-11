import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

export const deleteAccount = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { userId } = context;

    console.log("Starting account deletion for user:", userId);

    try {
      // 1. Delete messages where user is involved
      await supabaseAdmin.from("messages").delete().eq("sender_id", userId);
      console.log("Deleted messages for user:", userId);

      // 2. Delete notifications for the user
      await supabaseAdmin.from("notifications").delete().eq("user_id", userId);
      console.log("Deleted notifications for user:", userId);

      // 3. Delete ratings given by the user
      await supabaseAdmin.from("ratings").delete().eq("client_id", userId);
      console.log("Deleted ratings for user:", userId);

      // 4. Delete reports submitted by the user
      await supabaseAdmin.from("provider_reports").delete().eq("client_id", userId);
      console.log("Deleted reports for user:", userId);

      // 5. Check if user is a client and handle their service requests
      const { data: requests } = await supabaseAdmin
        .from("service_requests")
        .select("id")
        .eq("client_id", userId);

      if (requests && requests.length > 0) {
        const requestIds = requests.map(r => r.id);
        // Delete matches for these requests
        await supabaseAdmin.from("matches").delete().in("request_id", requestIds);
        console.log("Deleted matches for requests:", requestIds);
        // Delete the service requests
        await supabaseAdmin.from("service_requests").delete().in("id", requestIds);
        console.log("Deleted service requests for user:", userId);
      }

      // 6. Check if user is a provider and handle their data
      const { data: provider } = await supabaseAdmin
        .from("service_providers")
        .select("id")
        .eq("user_id", userId)
        .maybeSingle();

      if (provider) {
        console.log("Found provider data for user:", userId, "provider:", provider.id);
        
        // Delete documents for this provider
        await supabaseAdmin.from("documents").delete().eq("provider_id", provider.id);
        console.log("Deleted documents for provider:", provider.id);
        
        // Delete matches where this provider is involved
        await supabaseAdmin.from("matches").delete().eq("provider_id", provider.id);
        console.log("Deleted matches for provider:", provider.id);
        
        // Delete ratings for this provider
        await supabaseAdmin.from("ratings").delete().eq("provider_id", provider.id);
        console.log("Deleted ratings for provider:", provider.id);
        
        // Delete reports about this provider
        await supabaseAdmin.from("provider_reports").delete().eq("provider_id", provider.id);
        console.log("Deleted reports for provider:", provider.id);
        
        // Delete the provider record
        await supabaseAdmin.from("service_providers").delete().eq("id", provider.id);
        console.log("Deleted provider record:", provider.id);
      }

      // 7. Delete user profile
      await supabaseAdmin.from("profiles").delete().eq("id", userId);
      console.log("Deleted profile for user:", userId);

      // 8. Delete user role
      await supabaseAdmin.from("user_roles").delete().eq("user_id", userId);
      console.log("Deleted user role for user:", userId);

      // 9. Delete the auth user using admin client
      const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userId);
      
      if (deleteError) {
        console.error("Error deleting auth user:", deleteError);
        throw new Error(`Failed to delete auth user: ${deleteError.message}`);
      }

      console.log("Successfully deleted account for user:", userId);

      return { success: true };
    } catch (error) {
      console.error("Account deletion error:", error);
      throw error;
    }
  });