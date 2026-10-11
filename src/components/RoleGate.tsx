import { useEffect, type ReactNode } from "react";
import { useNavigate } from "@tanstack/react-router";
import { useAuth, type AppRole } from "@/lib/auth";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export function RoleGate({ allow, children }: { allow: AppRole[]; children: ReactNode }) {
  const { user, role, loading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    const checkEmailVerification = async () => {
      if (loading) return;
      if (!user) {
        navigate({ to: "/auth" });
        return;
      }
      
      // Check if email is verified (but allow admins to bypass for testing)
      if (!user.email_confirmed_at && role !== "admin") {
        console.log("Email not confirmed in RoleGate, signing out");
        toast.error("Please verify your email first. Check your inbox for the verification link.");
        await supabase.auth.signOut();
        navigate({ to: "/auth" });
        return;
      }
      
      if (role && !allow.includes(role)) {
        if (role === "admin") navigate({ to: "/admin" });
        else if (role === "provider") navigate({ to: "/provider" });
        else navigate({ to: "/dashboard" });
      }
    };

    checkEmailVerification();
  }, [user, role, loading, allow, navigate]);

  if (loading || !user || !role || !allow.includes(role)) {
    return (
      <div className="flex min-h-screen flex-col">
        <Navbar />
        <main className="flex flex-1 items-center justify-center">
          <p className="text-sm text-muted-foreground">Loading…</p>
        </main>
        <Footer />
      </div>
    );
  }
  return <>{children}</>;
}
