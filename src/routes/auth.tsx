import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useState, useEffect, useRef } from "react";
import { Navbar } from "@/components/Navbar";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Progress } from "@/components/ui/progress";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import {
  checkAccountLockout,
  recordFailedLoginAttempt,
  resetFailedLoginAttempts,
} from "@/server/auth.functions";
import { Check, X } from "lucide-react";

const LOCKOUT_DURATION_MINUTES = 15;

export const Route = createFileRoute("/auth")({
  component: AuthPage,
  head: () => ({
    meta: [
      { title: "Sign in — MatchWise" },
      { name: "description", content: "Sign in or create an account on MatchWise." },
    ],
  }),
});

function AuthPage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  // signup
  const [name, setName] = useState("");
  const [signupEmail, setSignupEmail] = useState("");
  const [signupPassword, setSignupPassword] = useState("");
  const [role, setRole] = useState<"client" | "provider">("client");
  // signin
  const [signinEmail, setSigninEmail] = useState("");
  const [signinPassword, setSigninPassword] = useState("");
  const [resendingEmail, setResendingEmail] = useState(false);
  const [isLocked, setIsLocked] = useState(false);
  const [lockoutTime, setLockoutTime] = useState<string | null>(null);
  const [minutesRemaining, setMinutesRemaining] = useState(0);
  const signinEmailRef = useRef(signinEmail);

  // Password strength calculation
  const getPasswordStrength = (password: string) => {
    let strength = 0;
    if (password.length >= 8) strength += 25;
    if (password.length >= 12) strength += 25;
    if (/[A-Z]/.test(password)) strength += 15;
    if (/[0-9]/.test(password)) strength += 15;
    if (/[^A-Za-z0-9]/.test(password)) strength += 20;
    return Math.min(strength, 100);
  };

  const passwordStrength = getPasswordStrength(signupPassword);
  const getPasswordColor = (strength: number) => {
    if (strength < 30) return "bg-destructive";
    if (strength < 60) return "bg-yellow-500";
    if (strength < 80) return "bg-blue-500";
    return "bg-green-500";
  };
  const getPasswordLabel = (strength: number) => {
    if (strength < 30) return "Weak";
    if (strength < 60) return "Fair";
    if (strength < 80) return "Good";
    return "Strong";
  };

  // Update ref when email changes
  useEffect(() => {
    signinEmailRef.current = signinEmail;
  }, [signinEmail]);

  // Check lockout status when email changes
  useEffect(() => {
    if (signinEmail && signinEmail.includes("@")) {
      checkAccountLockout({ data: { email: signinEmail } }).then((result) => {
        console.log("Lockout check result:", result);
        setIsLocked(result.isLocked);
        setLockoutTime(result.lockedUntil);
      });
    } else {
      setIsLocked(false);
      setLockoutTime(null);
    }
  }, [signinEmail]);

  // Update countdown timer when locked
  useEffect(() => {
    if (!isLocked || !lockoutTime) {
      setMinutesRemaining(0);
      return;
    }

    const updateTimer = () => {
      const remaining = Math.ceil((new Date(lockoutTime).getTime() - Date.now()) / (60 * 1000));
      setMinutesRemaining(Math.max(0, remaining));

      if (remaining <= 0) {
        // Lockout expired, recheck
        checkAccountLockout({ data: { email: signinEmailRef.current } }).then((result) => {
          setIsLocked(result.isLocked);
          setLockoutTime(result.lockedUntil);
        });
      }
    };

    updateTimer();
    const interval = setInterval(updateTimer, 1000);

    return () => clearInterval(interval);
  }, [isLocked, lockoutTime]);

  const redirectByRole = async (
    userId: string,
    session?: { user: { email_confirmed_at: string | null } } | null,
    retryCount = 0,
  ) => {
    try {
      // Small delay to let auth headers sync
      await new Promise((r) => setTimeout(r, 100));

      // Use provided session or get current one
      let currentSession = session;
      if (!currentSession) {
        const { data } = await supabase.auth.getSession();
        currentSession = data.session;
      }

      if (!currentSession) {
        console.error("No session available");
        navigate({ to: "/dashboard" });
        return;
      }

      const { data, error } = await supabase
        .from("user_roles")
        .select("role")
        .eq("user_id", userId)
        .limit(1)
        .maybeSingle();

      if (error) {
        // Retry on schema cache errors (503)
        const isRetryable =
          error.message?.includes("schema cache") ||
          error.message?.includes("Retrying") ||
          error.code === "503";
        if (isRetryable && retryCount < 3) {
          console.log(`Retrying role query (attempt ${retryCount + 1})...`);
          await new Promise((r) => setTimeout(r, 1000 * (retryCount + 1)));
          return redirectByRole(userId, currentSession, retryCount + 1);
        }

        console.error("Role query error:", error.message, error.details, error.hint);
        toast.error("Role check failed, defaulting to client");
        navigate({ to: "/dashboard" });
        return;
      }

      const r = String(data?.role ?? "client")
        .toLowerCase()
        .trim();
      console.log("User role:", r, "Raw data:", data);

      // CRITICAL: Check if email is verified before redirecting (but allow admins to bypass)
      if (!currentSession.user.email_confirmed_at && r !== "admin") {
        console.log("Email not confirmed during redirect, signing out");
        toast.error("Please verify your email first. Check your inbox for the verification link.");
        await supabase.auth.signOut();
        return;
      }

      if (r === "admin") navigate({ to: "/admin" });
      else if (r === "provider") navigate({ to: "/provider" });
      else navigate({ to: "/dashboard" });
    } catch (err) {
      console.error("Unexpected error in redirectByRole:", err);
      navigate({ to: "/dashboard" });
    }
  };

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    const { data, error } = await supabase.auth.signUp({
      email: signupEmail,
      password: signupPassword,
      options: {
        emailRedirectTo: `${window.location.origin}/verify-email`,
        data: { full_name: name, role },
      },
    });
    setLoading(false);
    if (error) {
      toast.error(error.message);
      return;
    }

    // Check if email confirmation is required
    if (data.user && !data.session) {
      toast.success("Account created! Please check your email to verify your account.");
      // Don't redirect - user needs to verify email first
      return;
    }

    // If email confirmation is not required or already verified
    toast.success("Welcome to MatchWise!");
    if (data.user) await redirectByRole(data.user.id, data.session);
  };

  const handleResendVerification = async () => {
    if (!signinEmail) {
      toast.error("Please enter your email address");
      return;
    }

    setResendingEmail(true);
    const { error } = await supabase.auth.resend({
      type: "signup",
      email: signinEmail,
    });
    setResendingEmail(false);

    if (error) {
      toast.error(error.message);
    } else {
      toast.success("Verification email sent successfully!");
    }
  };

  const handleSignin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Check if account is locked out
      const lockoutCheck = await checkAccountLockout({ data: { email: signinEmail } });
      console.log("Lockout check on sign-in:", lockoutCheck);

      if (lockoutCheck.isLocked) {
        const lockoutTime = new Date(lockoutCheck.lockedUntil!);
        const minutesLeft = Math.ceil((lockoutTime.getTime() - Date.now()) / (60 * 1000));
        toast.error(`Account locked. Try again in ${minutesLeft} minutes.`);
        setLoading(false);
        return;
      }

      const { data, error } = await supabase.auth.signInWithPassword({
        email: signinEmail,
        password: signinPassword,
      });

      if (error) {
        console.log("Sign in error:", error);
        console.log("Error message:", error.message);

        // Check if error is due to unverified email
        if (
          error.message.includes("Email not confirmed") ||
          error.message.includes("email_confirmed_at")
        ) {
          toast.error(
            "Please verify your email first. Check your inbox for the verification link.",
          );
          setLoading(false);
          return;
        }

        // Record failed attempt for any authentication error
        console.log("Recording failed attempt for:", signinEmail);
        const result = await recordFailedLoginAttempt({ data: { email: signinEmail } });
        console.log("Failed attempt result:", result);

        if (result.isLocked) {
          setIsLocked(true);
          setLockoutTime(result.lockedUntil);
          toast.error(`Too many failed attempts. Account locked for 15 minutes.`);
        } else {
          toast.error(`Invalid credentials. ${result.remainingAttempts} attempts remaining.`);
        }
        setLoading(false);
        return;
      }

      // Check if email is verified - this is the critical check
      if (data.user && !data.user.email_confirmed_at) {
        console.log("Email not confirmed, signing out user");
        toast.error("Please verify your email first. Check your inbox for the verification link.");
        await supabase.auth.signOut();
        setLoading(false);
        return;
      }

      // Reset failed attempts on successful login
      await resetFailedLoginAttempts({ data: { email: signinEmail } });

      toast.success("Welcome back!");
      if (data.user) await redirectByRole(data.user.id, data.session);
    } catch (err) {
      console.error("Sign in error:", err);
      toast.error("An error occurred during sign in");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />
      <main className="flex flex-1 items-center justify-center px-4 py-12">
        <Card className="w-full max-w-md p-8 shadow-soft">
          <div className="mb-6 text-center">
            <h1 className="text-2xl font-bold tracking-tight">Welcome to MatchWise</h1>
            <p className="mt-1 text-sm text-muted-foreground">Sign in or create an account</p>
          </div>

          <Tabs defaultValue="signin">
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="signin">Sign in</TabsTrigger>
              <TabsTrigger value="signup">Sign up</TabsTrigger>
            </TabsList>

            <TabsContent value="signin" className="mt-5">
              <form onSubmit={handleSignin} className="space-y-4">
                {isLocked && lockoutTime && (
                  <div className="rounded-lg bg-destructive/10 border border-destructive/20 p-3">
                    <p className="text-sm text-destructive font-medium">Account Locked</p>
                    <p className="text-xs text-destructive/80 mt-1">
                      Too many failed attempts. Try again in {minutesRemaining} minute
                      {minutesRemaining !== 1 ? "s" : ""}.
                    </p>
                  </div>
                )}
                <div className="space-y-1.5">
                  <Label htmlFor="si-email">Email</Label>
                  <Input
                    id="si-email"
                    type="email"
                    required
                    value={signinEmail}
                    onChange={(e) => setSigninEmail(e.target.value)}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="si-pwd">Password</Label>
                  <Input
                    id="si-pwd"
                    type="password"
                    required
                    minLength={6}
                    value={signinPassword}
                    onChange={(e) => setSigninPassword(e.target.value)}
                    disabled={isLocked}
                  />
                </div>
                <div className="flex justify-end">
                  <Link
                    to="/forgot-password"
                    className="text-sm text-muted-foreground hover:text-foreground"
                  >
                    Forgot password?
                  </Link>
                </div>
                <Button
                  type="submit"
                  className="w-full bg-black text-white shadow-sm"
                  disabled={loading || isLocked}
                >
                  {loading ? "Signing in…" : isLocked ? "Account Locked" : "Sign in"}
                </Button>
                <Button
                  type="button"
                  variant="ghost"
                  className="w-full text-sm"
                  onClick={handleResendVerification}
                  disabled={resendingEmail}
                >
                  {resendingEmail ? "Sending..." : "Resend verification email"}
                </Button>
              </form>
            </TabsContent>

            <TabsContent value="signup" className="mt-5">
              <form onSubmit={handleSignup} className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="su-name">Full name</Label>
                  <Input
                    id="su-name"
                    required
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="su-email">Email</Label>
                  <Input
                    id="su-email"
                    type="email"
                    required
                    value={signupEmail}
                    onChange={(e) => setSignupEmail(e.target.value)}
                  />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="su-pwd">Password</Label>
                  <Input
                    id="su-pwd"
                    type="password"
                    required
                    minLength={6}
                    value={signupPassword}
                    onChange={(e) => setSignupPassword(e.target.value)}
                  />
                  {signupPassword && (
                    <div className="space-y-2">
                      <div className="flex items-center gap-2">
                        <Progress value={passwordStrength} className="flex-1 h-2" />
                        <span className="text-xs text-muted-foreground w-12">
                          {getPasswordLabel(passwordStrength)}
                        </span>
                      </div>
                      <div className="grid grid-cols-2 gap-1 text-xs">
                        <div
                          className={`flex items-center gap-1 ${signupPassword.length >= 8 ? "text-green-600" : "text-muted-foreground"}`}
                        >
                          {signupPassword.length >= 8 ? (
                            <Check className="w-3 h-3" />
                          ) : (
                            <X className="w-3 h-3" />
                          )}
                          <span>8+ characters</span>
                        </div>
                        <div
                          className={`flex items-center gap-1 ${/[A-Z]/.test(signupPassword) ? "text-green-600" : "text-muted-foreground"}`}
                        >
                          {/[A-Z]/.test(signupPassword) ? (
                            <Check className="w-3 h-3" />
                          ) : (
                            <X className="w-3 h-3" />
                          )}
                          <span>Uppercase letter</span>
                        </div>
                        <div
                          className={`flex items-center gap-1 ${/[0-9]/.test(signupPassword) ? "text-green-600" : "text-muted-foreground"}`}
                        >
                          {/[0-9]/.test(signupPassword) ? (
                            <Check className="w-3 h-3" />
                          ) : (
                            <X className="w-3 h-3" />
                          )}
                          <span>Number</span>
                        </div>
                        <div
                          className={`flex items-center gap-1 ${/[^A-Za-z0-9]/.test(signupPassword) ? "text-green-600" : "text-muted-foreground"}`}
                        >
                          {/[^A-Za-z0-9]/.test(signupPassword) ? (
                            <Check className="w-3 h-3" />
                          ) : (
                            <X className="w-3 h-3" />
                          )}
                          <span>Special character</span>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
                <div className="space-y-2">
                  <Label>I am a…</Label>
                  <RadioGroup
                    value={role}
                    onValueChange={(v) => setRole(v as "client" | "provider")}
                    className="grid grid-cols-2 gap-2"
                  >
                    <Label
                      htmlFor="r-client"
                      className="flex cursor-pointer items-center gap-2 rounded-lg border border-border p-3 hover:bg-muted/50 has-[:checked]:border-primary has-[:checked]:bg-primary/5"
                    >
                      <RadioGroupItem id="r-client" value="client" />
                      <span className="text-sm font-medium">Client</span>
                    </Label>
                    <Label
                      htmlFor="r-provider"
                      className="flex cursor-pointer items-center gap-2 rounded-lg border border-border p-3 hover:bg-muted/50 has-[:checked]:border-primary has-[:checked]:bg-primary/5"
                    >
                      <RadioGroupItem id="r-provider" value="provider" />
                      <span className="text-sm font-medium">Provider</span>
                    </Label>
                  </RadioGroup>
                </div>
                <Button
                  type="submit"
                  className="w-full bg-black text-white shadow-sm"
                  disabled={loading}
                >
                  {loading ? "Creating account…" : "Create account"}
                </Button>
              </form>
            </TabsContent>
          </Tabs>
        </Card>
      </main>
    </div>
  );
}
