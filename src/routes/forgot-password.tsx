import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/forgot-password")({
  component: ForgotPasswordPage,
  head: () => ({
    meta: [
      { title: "Forgot Password — MatchWise" },
      { name: "description", content: "Reset your MatchWise password." },
    ],
  }),
});

function ForgotPasswordPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`,
    });

    setLoading(false);

    if (error) {
      toast.error(error.message);
      return;
    }

    setSent(true);
    toast.success("Password reset email sent! Check your inbox.");
  };

  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />
      <main className="flex flex-1 items-center justify-center px-4 py-12">
        <Card className="w-full max-w-md p-8 shadow-soft">
          <div className="mb-6 text-center">
            <h1 className="text-2xl font-bold tracking-tight">Forgot Password?</h1>
            <p className="mt-1 text-sm text-muted-foreground">
              {sent 
                ? "Check your email for the reset link"
                : "Enter your email address and we'll send you a reset link"
              }
            </p>
          </div>

          {!sent ? (
            <form onSubmit={handleResetPassword} className="space-y-4">
              <div className="space-y-1.5">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="you@example.com"
                />
              </div>
              <Button
                type="submit"
                className="w-full bg-black text-white shadow-sm"
                disabled={loading}
              >
                {loading ? "Sending..." : "Send Reset Link"}
              </Button>
            </form>
          ) : (
            <div className="space-y-4">
              <div className="rounded-lg bg-muted p-4 text-center">
                <p className="text-sm text-muted-foreground">
                  We've sent a password reset link to <strong>{email}</strong>
                </p>
              </div>
              <Button
                type="button"
                variant="outline"
                className="w-full"
                onClick={() => {
                  setSent(false);
                  setEmail("");
                }}
              >
                Try another email
              </Button>
            </div>
          )}

          <div className="mt-6 text-center">
            <button
              type="button"
              onClick={() => navigate({ to: "/auth" })}
              className="text-sm text-muted-foreground hover:text-foreground"
            >
              Back to sign in
            </button>
          </div>
        </Card>
      </main>
    </div>
  );
}
