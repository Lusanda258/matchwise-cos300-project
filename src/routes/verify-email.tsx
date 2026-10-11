import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/verify-email")({
  component: VerifyEmailPage,
  head: () => ({
    meta: [
      { title: "Verify Email — MatchWise" },
      { name: "description", content: "Verify your email address to complete registration." },
    ],
  }),
});

function VerifyEmailPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [verified, setVerified] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const verifyEmail = async () => {
      try {
        // Get the current session
        const { data: { session }, error: sessionError } = await supabase.auth.getSession();
        
        if (sessionError) {
          setError(sessionError.message);
          setLoading(false);
          return;
        }

        if (!session) {
          // No session, redirect to auth page
          navigate({ to: "/auth" });
          return;
        }

        // Check if email is already verified
        if (session.user.email_confirmed_at) {
          setVerified(true);
          setLoading(false);
          // Redirect to appropriate dashboard after a short delay
          setTimeout(() => {
            navigate({ to: "/dashboard" });
          }, 2000);
          return;
        }

        // Try to verify the email using the token from URL
        const hashParams = new URLSearchParams(window.location.hash.substring(1));
        const accessToken = hashParams.get("access_token");
        
        if (accessToken) {
          const { error: verifyError } = await supabase.auth.getUser(accessToken);
          if (verifyError) {
            setError(verifyError.message);
          } else {
            setVerified(true);
            toast.success("Email verified successfully!");
            // Redirect after a short delay
            setTimeout(() => {
              navigate({ to: "/dashboard" });
            }, 2000);
          }
        } else {
          setError("No verification token found. Please check your email for the verification link.");
        }
      } catch (err) {
        setError("An error occurred during email verification");
        console.error("Verification error:", err);
      } finally {
        setLoading(false);
      }
    };

    verifyEmail();
  }, [navigate]);

  const handleResendEmail = async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session?.user?.email) {
        toast.error("No active session found");
        return;
      }

      const { error } = await supabase.auth.resend({
        type: 'signup',
        email: session.user.email,
      });

      if (error) {
        toast.error(error.message);
      } else {
        toast.success("Verification email sent successfully!");
      }
    } catch (err) {
      toast.error("Failed to resend verification email");
      console.error("Resend error:", err);
    }
  };

  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />
      <main className="flex flex-1 items-center justify-center px-4 py-12">
        <Card className="w-full max-w-md p-8 shadow-soft">
          <div className="text-center">
            {loading ? (
              <>
                <div className="mb-4 flex justify-center">
                  <div className="h-8 w-8 animate-spin rounded-full border-4 border-gray-300 border-t-black"></div>
                </div>
                <h1 className="text-2xl font-bold tracking-tight">Verifying your email...</h1>
                <p className="mt-2 text-sm text-muted-foreground">Please wait while we verify your email address.</p>
              </>
            ) : verified ? (
              <>
                <div className="mb-4 flex justify-center">
                  <div className="flex h-16 w-16 items-center justify-center rounded-full bg-green-100">
                    <svg className="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                    </svg>
                  </div>
                </div>
                <h1 className="text-2xl font-bold tracking-tight">Email Verified!</h1>
                <p className="mt-2 text-sm text-muted-foreground">Your email has been successfully verified. Redirecting you to the dashboard...</p>
              </>
            ) : (
              <>
                <div className="mb-4 flex justify-center">
                  <div className="flex h-16 w-16 items-center justify-center rounded-full bg-red-100">
                    <svg className="h-8 w-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </div>
                </div>
                <h1 className="text-2xl font-bold tracking-tight">Verification Failed</h1>
                <p className="mt-2 text-sm text-muted-foreground">{error || "We couldn't verify your email address."}</p>
                <div className="mt-6 space-y-3">
                  <Button 
                    onClick={handleResendEmail}
                    className="w-full bg-black text-white shadow-sm"
                  >
                    Resend Verification Email
                  </Button>
                  <Button 
                    onClick={() => navigate({ to: "/auth" })}
                    variant="outline"
                    className="w-full"
                  >
                    Back to Sign In
                  </Button>
                </div>
              </>
            )}
          </div>
        </Card>
      </main>
    </div>
  );
}