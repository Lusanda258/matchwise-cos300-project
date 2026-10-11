import { useEffect, useState } from "react";
import type { Session, User } from "@supabase/supabase-js";
import { supabase } from "@/integrations/supabase/client";

export type AppRole = "client" | "provider" | "admin";

export interface AuthState {
  user: User | null;
  session: Session | null;
  role: AppRole | null;
  loading: boolean;
}

export function useAuth(): AuthState {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [role, setRole] = useState<AppRole | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, sess) => {
      setSession(sess);
      setUser(sess?.user ?? null);
      if (sess?.user) {
        // Check if email is verified, but fetch role first to allow admin bypass
        setTimeout(async () => {
          const { data } = await supabase
            .from("user_roles")
            .select("role")
            .eq("user_id", sess.user.id)
            .order("role", { ascending: true })
            .limit(1)
            .maybeSingle();
          // Normalize enum value to string
          const roleValue = String(data?.role ?? "client").toLowerCase().trim();
          const finalRole = (roleValue as AppRole) ?? "client";
          
          // Check if email is verified (but allow admins to bypass)
          if (!sess.user.email_confirmed_at && finalRole !== "admin") {
            console.log("Email not confirmed in auth state change");
            setRole(null);
            setLoading(false);
            return;
          }
          
          setRole(finalRole);
        }, 0);
      } else {
        setRole(null);
      }
    });

    supabase.auth.getSession().then(async ({ data: { session: sess } }) => {
      setSession(sess);
      setUser(sess?.user ?? null);
      if (sess?.user) {
        const { data } = await supabase
          .from("user_roles")
          .select("role")
          .eq("user_id", sess.user.id)
          .limit(1)
          .maybeSingle();
        // Normalize enum value to string
        const roleValue = String(data?.role ?? "client").toLowerCase().trim();
        const finalRole = (roleValue as AppRole) ?? "client";
        
        // Check if email is verified (but allow admins to bypass)
        if (!sess.user.email_confirmed_at && finalRole !== "admin") {
          console.log("Email not confirmed in initial session check");
          setRole(null);
          setLoading(false);
          return;
        }
        
        setRole(finalRole);
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  return { user, session, role, loading };
}

export async function signOut() {
  await supabase.auth.signOut();
  window.location.href = "/";
}
