import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { completeOnboarding } from "@/server/onboarding.functions";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { Sparkles, Star, MessageSquare, Heart, Clock, CheckCircle, ArrowRight, ArrowLeft } from "lucide-react";

interface OnboardingDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

const onboardingSteps = [
  {
    icon: Sparkles,
    title: "Welcome to MatchWise!",
    description: "Your AI-powered platform for finding the perfect service providers. Let's show you around.",
  },
  {
    icon: Sparkles,
    title: "AI-Powered Matching",
    description: "Describe what you need in your own words, and our AI will find the best providers for you based on skills, location, and ratings.",
  },
  {
    icon: Star,
    title: "Browse Providers",
    description: "Explore our curated list of verified service providers with detailed profiles, ratings, and reviews.",
  },
  {
    icon: MessageSquare,
    title: "Chat with Providers",
    description: "Once matched, you can chat directly with providers to discuss details and coordinate services.",
  },
  {
    icon: Heart,
    title: "Save Favorites",
    description: "Add providers to your favorites to quickly access them for future requests.",
  },
  {
    icon: Clock,
    title: "Track Progress",
    description: "Monitor your active and completed requests in one place. Get real-time updates on job status.",
  },
  {
    icon: CheckCircle,
    title: "Rate & Review",
    description: "After service completion, rate providers to help others make informed decisions and improve the community.",
  },
];

export function OnboardingDialog({ open, onOpenChange }: OnboardingDialogProps) {
  const [currentStep, setCurrentStep] = useState(0);

  const completeOnboardingMutation = useMutation({
    mutationFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) throw new Error("User not authenticated");
      
      const res = await completeOnboarding({
        headers: { Authorization: `Bearer ${session.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Welcome aboard! You're all set.");
      onOpenChange(false);
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to complete onboarding");
    },
  });

  const handleNext = () => {
    if (currentStep < onboardingSteps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      completeOnboardingMutation.mutate();
    }
  };

  const handlePrevious = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSkip = () => {
    completeOnboardingMutation.mutate();
  };

  const currentStepData = onboardingSteps[currentStep];
  const Icon = currentStepData.icon;
  const isLastStep = currentStep === onboardingSteps.length - 1;
  const progress = ((currentStep + 1) / onboardingSteps.length) * 100;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <div className="flex items-center gap-2 mb-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-hero text-white">
              <Icon className="w-4 h-4" />
            </div>
            <DialogTitle className="text-xl">{currentStepData.title}</DialogTitle>
          </div>
          <DialogDescription className="text-base">
            {currentStepData.description}
          </DialogDescription>
        </DialogHeader>

        {/* Progress bar */}
        <div className="w-full bg-muted rounded-full h-2 mb-4">
          <div 
            className="bg-gradient-hero h-2 rounded-full transition-all duration-300" 
            style={{ width: `${progress}%` }}
          />
        </div>

        {/* Step indicators */}
        <div className="flex justify-center gap-2 mb-4">
          {onboardingSteps.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentStep(index)}
              className={`h-2 rounded-full transition-all ${
                index === currentStep 
                  ? "w-8 bg-gradient-hero" 
                  : index < currentStep 
                    ? "w-2 bg-success" 
                    : "w-2 bg-muted"
              }`}
              aria-label={`Go to step ${index + 1}`}
            />
          ))}
        </div>

        {/* Visual card for current step */}
        <Card className="p-6 bg-gradient-to-br from-primary/5 to-secondary/5 border-2 border-primary/20 mb-4">
          <div className="flex flex-col items-center text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-hero text-white mb-4 shadow-lg">
              <Icon className="w-8 h-8" />
            </div>
            <p className="text-sm text-muted-foreground">
              Step {currentStep + 1} of {onboardingSteps.length}
            </p>
          </div>
        </Card>

        <DialogFooter className="flex-col sm:flex-row gap-2">
          <Button
            type="button"
            variant="ghost"
            onClick={handleSkip}
            className="text-sm"
            disabled={completeOnboardingMutation.isPending}
          >
            Skip tour
          </Button>
          <div className="flex gap-2 w-full sm:w-auto">
            <Button
              type="button"
              variant="outline"
              onClick={handlePrevious}
              disabled={currentStep === 0 || completeOnboardingMutation.isPending}
              className="flex-1 sm:flex-none"
            >
              <ArrowLeft className="w-4 h-4 mr-2" />
              Previous
            </Button>
            <Button
              type="button"
              onClick={handleNext}
              disabled={completeOnboardingMutation.isPending}
              className="flex-1 sm:flex-none bg-gradient-hero text-white"
            >
              {isLastStep ? (
                <>
                  Get Started
                  <CheckCircle className="w-4 h-4 ml-2" />
                </>
              ) : (
                <>
                  Next
                  <ArrowRight className="w-4 h-4 ml-2" />
                </>
              )}
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
