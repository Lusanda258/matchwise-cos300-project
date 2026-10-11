import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { Navbar } from "@/components/Navbar";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/reset-password")({
  component: ResetPasswordPage,
  head: () => ({
    meta: [
      { title: "Reset Password — MatchWise" },
      { name: "description", content: "Set your new password on MatchWise." },
    ],
  }),
});

function ResetPasswordPage() {
  const navigate = useNavigate();
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [isValidLink, setIsValidLink] = useState(true);

  useEffect(() => {
    // Check if we have a valid session from the reset link
    const checkSession = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) {
        setIsValidLink(false);
      }
    };
    checkSession();
  }, []);

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();

    if (password.length < 6) {
      toast.error("Password must be at least 6 characters");
      return;
    }

    if (password !== confirmPassword) {
      toast.error("Passwords do not match");
      return;
    }

    setLoading(true);

    const { error } = await supabase.auth.updateUser({
      password: password,
    });

    setLoading(false);

    if (error) {
      toast.error(error.message);
      return;
    }

    toast.success("Password updated successfully!");

    // Sign out the user after password reset
    await supabase.auth.signOut();

    // Redirect to sign in page
    navigate({ to: "/auth" });
  };

  if (!isValidLink) {
    return (
      <div className="flex min-h-screen flex-col bg-white">
        <Navbar />
        <main className="flex flex-1 items-center justify-center px-4 py-12">
          <Card className="w-full max-w-md p-8 shadow-soft">
            <div className="mb-6 text-center">
              <h1 className="text-2xl font-bold tracking-tight">Invalid or Expired Link</h1>
              <p className="mt-1 text-sm text-muted-foreground">
                This password reset link is invalid or has expired. Please request a new one.
              </p>
            </div>
            <Button
              type="button"
              className="w-full bg-black text-white shadow-sm"
              onClick={() => navigate({ to: "/forgot-password" })}
            >
              Request New Reset Link
            </Button>
          </Card>
        </main>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />
      <main className="flex flex-1 items-center justify-center px-4 py-12">
        <Card className="w-full max-w-md p-8 shadow-soft">
          <div className="mb-6 text-center">
            <h1 className="text-2xl font-bold tracking-tight">Reset Password</h1>
            <p className="mt-1 text-sm text-muted-foreground">
              Enter your new password below
            </p>
          </div>

          <form onSubmit={handleResetPassword} className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="password">New Password</Label>
              <Input
                id="password"
                type="password"
                required
                minLength={6}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="confirm-password">Confirm New Password</Label>
              <Input
                id="confirm-password"
                type="password"
                required
                minLength={6}
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="••••••••"
              />
            </div>
            <Button
              type="submit"
              className="w-full bg-black text-white shadow-sm"
              disabled={loading}
            >
              {loading ? "Updating..." : "Update Password"}
            </Button>
          </form>

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
