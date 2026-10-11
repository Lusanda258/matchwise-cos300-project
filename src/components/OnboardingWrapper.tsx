import { useEffect, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { OnboardingDialog } from "@/components/OnboardingDialog";
import { checkOnboardingStatus } from "@/server/onboarding.functions";
import { supabase } from "@/integrations/supabase/client";

interface OnboardingWrapperProps {
  children: React.ReactNode;
}

export function OnboardingWrapper({ children }: OnboardingWrapperProps) {
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [isChecked, setIsChecked] = useState(false);

  const { data: onboardingStatus, isLoading } = useQuery({
    queryKey: ["onboardingStatus"],
    queryFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) return { hasCompletedOnboarding: true };
      
      try {
        const res = await checkOnboardingStatus({
          headers: { Authorization: `Bearer ${session.access_token}` },
        });
        return res;
      } catch (error) {
        console.error("Error checking onboarding status:", error);
        return { hasCompletedOnboarding: true };
      }
    },
    enabled: !isChecked,
  });

  useEffect(() => {
    if (!isLoading && onboardingStatus) {
      setIsChecked(true);
      if (!onboardingStatus.hasCompletedOnboarding) {
        setShowOnboarding(true);
      }
    }
  }, [isLoading, onboardingStatus]);

  return (
    <>
      {children}
      <OnboardingDialog 
        open={showOnboarding} 
        onOpenChange={setShowOnboarding} 
      />
    </>
  );
}
