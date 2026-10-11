import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";

export const checkOnboardingStatus = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: onboarding, error } = await supabase
      .from("user_onboarding")
      .select("*")
      .eq("user_id", userId)
      .single();

    if (error && error.code !== "PGRST116") {
      // PGRST116 is "not found" error, which is expected for new users
      throw new Error(error.message);
    }

    return { hasCompletedOnboarding: !!onboarding };
  });

export const completeOnboarding = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    // Check if already completed
    const { data: existingOnboarding } = await supabase
      .from("user_onboarding")
      .select("*")
      .eq("user_id", userId)
      .single();

    if (existingOnboarding) {
      return { success: true, alreadyCompleted: true };
    }

    // Mark onboarding as completed
    const { error: insertErr } = await supabase
      .from("user_onboarding")
      .insert({
        user_id: userId,
      });

    if (insertErr) throw new Error(insertErr.message);

    return { success: true };
  });
