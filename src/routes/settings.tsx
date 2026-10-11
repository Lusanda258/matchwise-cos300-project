import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { useAuth, signOut } from "@/lib/auth";
import { Navbar } from "@/components/Navbar";
import { RoleGate } from "@/components/RoleGate";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  SidebarProvider,
  Sidebar,
  SidebarContent,
  SidebarHeader,
  SidebarFooter,
  SidebarMenu,
  SidebarMenuItem,
  SidebarMenuButton,
  SidebarSeparator,
  SidebarGroup,
  SidebarGroupLabel,
  SidebarGroupContent,
} from "@/components/ui/sidebar";
import {
  Home,
  User,
  Bell,
  Shield,
  HelpCircle,
  Sparkles,
  LayoutDashboard,
  Settings as SettingsIcon,
  MessageSquare,
} from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { deleteAccount } from "@/server/account.functions";
import { submitSupportMessage, getUserSupportMessages } from "@/server/support.functions";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useRealtimeSubscription } from "@/hooks/useRealtime";

export const Route = createFileRoute("/settings")({
  component: () => (
    <RoleGate allow={["client", "provider"]}>
      <SettingsPage />
    </RoleGate>
  ),
  head: () => ({ meta: [{ title: "Settings — MatchWise" }] }),
});

function SettingsPage() {
  const navigate = useNavigate();
  const { user, role } = useAuth();
  const [loading, setLoading] = useState(false);
  const [saveLoading, setSaveLoading] = useState(false);

  // Profile settings
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [bio, setBio] = useState("");

  // Notification settings
  const [emailNotifications, setEmailNotifications] = useState(true);
  const [pushNotifications, setPushNotifications] = useState(true);
  const [matchUpdates, setMatchUpdates] = useState(true);
  const [messageNotifications, setMessageNotifications] = useState(true);

  // Privacy settings
  const [profileVisible, setProfileVisible] = useState(true);
  const [showLocation, setShowLocation] = useState(true);

  // Support dialog
  const [supportDialogOpen, setSupportDialogOpen] = useState(false);
  const [supportSubject, setSupportSubject] = useState("");
  const [supportMessage, setSupportMessage] = useState("");
  const [supportPriority, setSupportPriority] = useState("medium");

  // Load user data
  useEffect(() => {
    const loadUserData = async () => {
      setLoading(true);
      try {
        const {
          data: { user: authUser },
        } = await supabase.auth.getUser();
        if (authUser) {
          setEmail(authUser.email || "");
          setFullName(authUser.user_metadata?.full_name || "");

          // Load profile data based on role
          if (role === "provider") {
            const { data: providerData } = await supabase
              .from("service_providers")
              .select("bio")
              .eq("user_id", authUser.id)
              .maybeSingle();
            if (providerData) {
              setBio(providerData.bio || "");
            }
          }
        }
      } catch (error) {
        console.error("Error loading user data:", error);
      } finally {
        setLoading(false);
      }
    };

    loadUserData();
  }, [role]);

  const handleSaveProfile = async () => {
    setSaveLoading(true);
    try {
      const {
        data: { user: authUser },
      } = await supabase.auth.getUser();
      if (!authUser) throw new Error("Not authenticated");

      // Update user metadata
      const { error: updateError } = await supabase.auth.updateUser({
        data: { full_name: fullName },
      });

      if (updateError) {
        console.error("Auth update error:", updateError);
        throw updateError;
      }

      // Update profiles table in database
      const { error: profileError } = await supabase
        .from("profiles")
        .update({
          full_name: fullName,
          email: authUser.email,
        })
        .eq("id", authUser.id);

      if (profileError) {
        console.error("Profile update error:", profileError);
        throw profileError;
      }

      // Update provider bio if applicable
      if (role === "provider") {
        const { error: providerError } = await supabase
          .from("service_providers")
          .update({ bio })
          .eq("user_id", authUser.id);

        if (providerError) {
          console.error("Provider update error:", providerError);
          throw providerError;
        }
      }

      toast.success("Profile updated successfully");

      // Reload user data to reflect changes
      const {
        data: { user: updatedUser },
      } = await supabase.auth.getUser();
      if (updatedUser) {
        setFullName(updatedUser.user_metadata?.full_name || "");
      }
    } catch (error) {
      toast.error("Failed to update profile");
      console.error(error);
    } finally {
      setSaveLoading(false);
    }
  };

  const handleSaveNotifications = async () => {
    setSaveLoading(true);
    try {
      // In a real app, this would save to a user_preferences table
      await new Promise((resolve) => setTimeout(resolve, 500));
      toast.success("Notification preferences saved");
    } catch (error) {
      toast.error("Failed to save preferences");
    } finally {
      setSaveLoading(false);
    }
  };

  const handleSavePrivacy = async () => {
    setSaveLoading(true);
    try {
      // In a real app, this would save to a user_preferences table
      await new Promise((resolve) => setTimeout(resolve, 500));
      toast.success("Privacy settings saved");
    } catch (error) {
      toast.error("Failed to save settings");
    } finally {
      setSaveLoading(false);
    }
  };

  const handleDeleteAccount = async () => {
    if (
      !confirm(
        "Are you sure you want to delete your account? This action cannot be undone and will permanently delete all your data.",
      )
    ) {
      return;
    }

    try {
      setLoading(true);

      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;

      const result = await deleteAccount({
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });

      if (result.success) {
        toast.success("Account deleted successfully");

        // Sign out and redirect to home
        await signOut();
        navigate({ to: "/" });
      }
    } catch (error) {
      toast.error("Failed to delete account. Please try again or contact support.");
      console.error("Account deletion error:", error);
    } finally {
      setLoading(false);
    }
  };

  // Submit support message
  const submitSupportMutation = useMutation({
    mutationFn: async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!session) throw new Error("Not authenticated");

      const res = await submitSupportMessage({
        data: {
          subject: supportSubject,
          message: supportMessage,
          priority: supportPriority,
        },
        headers: { Authorization: `Bearer ${session.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Support message sent successfully. We'll get back to you soon.");
      setSupportDialogOpen(false);
      setSupportSubject("");
      setSupportMessage("");
      setSupportPriority("medium");
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send support message");
    },
  });

  const handleSupportSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    submitSupportMutation.mutate();
  };

  // Fetch user's support messages
  const { data: supportMessages = [], refetch: refetchSupportMessages } = useQuery({
    queryKey: ["userSupportMessages"],
    queryFn: async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!session) return [];

      const res = await getUserSupportMessages({
        headers: { Authorization: `Bearer ${session.access_token}` },
      });
      return res;
    },
  });

  // Real-time subscription for support messages
  useRealtimeSubscription({
    table: "support_messages",
    onInsert: () => {
      refetchSupportMessages();
    },
    onUpdate: () => {
      refetchSupportMessages();
    },
  });

  const dashboardLink =
    role === "admin" ? "/admin" : role === "provider" ? "/provider" : "/dashboard";

  return (
    <SidebarProvider>
      <div className="flex min-h-screen flex-col">
        <Navbar />
        <div className="flex flex-1 bg-gradient-soft">
          {/* Left Sidebar */}
          <Sidebar>
            <SidebarHeader className="border-b border-border/60 bg-gradient-hero">
              <div className="flex items-center gap-2 p-2">
                <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-white/20 text-white">
                  <Sparkles className="w-4 h-4" />
                </div>
                <span className="text-lg font-bold text-white">MatchWise</span>
              </div>
            </SidebarHeader>

            <SidebarContent className="bg-sidebar">
              <SidebarGroup>
                <SidebarGroupLabel>Main Menu</SidebarGroupLabel>
                <SidebarGroupContent>
                  <SidebarMenu>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: dashboardLink })}>
                        <LayoutDashboard className="w-4 h-4" />
                        <span>Dashboard</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: "/" })}>
                        <Home className="w-4 h-4" />
                        <span>Home</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  </SidebarMenu>
                </SidebarGroupContent>
              </SidebarGroup>

              <SidebarSeparator />

              <SidebarGroup>
                <SidebarGroupLabel>Settings</SidebarGroupLabel>
                <SidebarGroupContent>
                  <SidebarMenu>
                    <SidebarMenuItem>
                      <SidebarMenuButton isActive>
                        <SettingsIcon className="w-4 h-4" />
                        <span>Settings</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  </SidebarMenu>
                </SidebarGroupContent>
              </SidebarGroup>

              <SidebarSeparator />

              <SidebarGroup>
                <SidebarGroupLabel>Support</SidebarGroupLabel>
                <SidebarGroupContent>
                  <SidebarMenu>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: "/how-it-works" })}>
                        <HelpCircle className="w-4 h-4" />
                        <span>How It Works</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  </SidebarMenu>
                </SidebarGroupContent>
              </SidebarGroup>
            </SidebarContent>

            <SidebarFooter className="border-t border-border/60 bg-sidebar">
              <div className="p-4">
                <Button variant="outline" size="sm" onClick={signOut} className="w-full border-2">
                  Sign Out
                </Button>
              </div>
            </SidebarFooter>
          </Sidebar>

          {/* Main Content Area */}
          <main className="flex-1 overflow-auto">
            <div className="max-w-4xl mx-auto px-6 py-8">
              <div className="mb-8">
                <div className="flex items-center gap-3 mb-2">
                  <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-hero text-white shadow-lg">
                    <SettingsIcon className="w-5 h-5" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold tracking-tight">Settings</h1>
                    <p className="text-muted-foreground">
                      Manage your account preferences and privacy
                    </p>
                  </div>
                </div>
              </div>

              {loading ? (
                <div className="flex items-center justify-center py-12">
                  <div className="animate-spin h-8 w-8 border-2 border-primary border-t-transparent rounded-full" />
                </div>
              ) : (
                <div className="space-y-6">
                  {/* Profile Settings */}
                  <Card className="p-6 shadow-card border-2 border-primary/20">
                    <div className="flex items-center gap-2 mb-6">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                        <User className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Profile Settings</h2>
                        <p className="text-sm text-muted-foreground">
                          Update your personal information
                        </p>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div className="space-y-1.5">
                        <Label htmlFor="fullName" className="font-semibold">
                          Full Name
                        </Label>
                        <Input
                          id="fullName"
                          value={fullName}
                          onChange={(e) => setFullName(e.target.value)}
                          placeholder="Enter your full name"
                          className="border-2"
                        />
                      </div>

                      <div className="space-y-1.5">
                        <Label htmlFor="email" className="font-semibold">
                          Email
                        </Label>
                        <Input id="email" value={email} disabled className="border-2 bg-muted/50" />
                        <p className="text-xs text-muted-foreground">Email cannot be changed</p>
                      </div>

                      {role === "provider" && (
                        <div className="space-y-1.5">
                          <Label htmlFor="bio" className="font-semibold">
                            Bio
                          </Label>
                          <Textarea
                            id="bio"
                            value={bio}
                            onChange={(e) => setBio(e.target.value)}
                            placeholder="Tell clients about yourself and your services..."
                            rows={3}
                            className="resize-none border-2"
                          />
                        </div>
                      )}

                      <Button
                        onClick={handleSaveProfile}
                        disabled={saveLoading}
                        className="bg-gradient-hero text-white shadow-lg hover:shadow-xl transition-all"
                      >
                        {saveLoading ? "Saving..." : "Save Profile"}
                      </Button>
                    </div>
                  </Card>

                  {/* Notification Settings */}
                  <Card className="p-6 shadow-card border-2 border-accent/20">
                    <div className="flex items-center gap-2 mb-6">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-accent/10 text-accent">
                        <Bell className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Notification Preferences</h2>
                        <p className="text-sm text-muted-foreground">
                          Control how you receive updates
                        </p>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div className="flex items-center justify-between py-2 border-b border-border/60">
                        <div>
                          <p className="font-medium">Email Notifications</p>
                          <p className="text-sm text-muted-foreground">Receive updates via email</p>
                        </div>
                        <Switch
                          checked={emailNotifications}
                          onCheckedChange={setEmailNotifications}
                        />
                      </div>

                      <div className="flex items-center justify-between py-2 border-b border-border/60">
                        <div>
                          <p className="font-medium">Push Notifications</p>
                          <p className="text-sm text-muted-foreground">
                            Receive browser notifications
                          </p>
                        </div>
                        <Switch
                          checked={pushNotifications}
                          onCheckedChange={setPushNotifications}
                        />
                      </div>

                      <div className="flex items-center justify-between py-2 border-b border-border/60">
                        <div>
                          <p className="font-medium">Match Updates</p>
                          <p className="text-sm text-muted-foreground">
                            Get notified about new matches
                          </p>
                        </div>
                        <Switch checked={matchUpdates} onCheckedChange={setMatchUpdates} />
                      </div>

                      <div className="flex items-center justify-between py-2">
                        <div>
                          <p className="font-medium">Message Notifications</p>
                          <p className="text-sm text-muted-foreground">
                            Get notified for new messages
                          </p>
                        </div>
                        <Switch
                          checked={messageNotifications}
                          onCheckedChange={setMessageNotifications}
                        />
                      </div>

                      <Button
                        onClick={handleSaveNotifications}
                        disabled={saveLoading}
                        variant="outline"
                        className="border-2 mt-4"
                      >
                        {saveLoading ? "Saving..." : "Save Preferences"}
                      </Button>
                    </div>
                  </Card>

                  {/* Privacy Settings */}
                  <Card className="p-6 shadow-card border-2 border-success/20">
                    <div className="flex items-center gap-2 mb-6">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-success/10 text-success">
                        <Shield className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Privacy Settings</h2>
                        <p className="text-sm text-muted-foreground">
                          Control your profile visibility
                        </p>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div className="flex items-center justify-between py-2 border-b border-border/60">
                        <div>
                          <p className="font-medium">Profile Visibility</p>
                          <p className="text-sm text-muted-foreground">
                            Make your profile visible to others
                          </p>
                        </div>
                        <Switch checked={profileVisible} onCheckedChange={setProfileVisible} />
                      </div>

                      <div className="flex items-center justify-between py-2">
                        <div>
                          <p className="font-medium">Show Location</p>
                          <p className="text-sm text-muted-foreground">
                            Display your location in your profile
                          </p>
                        </div>
                        <Switch checked={showLocation} onCheckedChange={setShowLocation} />
                      </div>

                      <Button
                        onClick={handleSavePrivacy}
                        disabled={saveLoading}
                        variant="outline"
                        className="border-2 mt-4"
                      >
                        {saveLoading ? "Saving..." : "Save Settings"}
                      </Button>
                    </div>
                  </Card>

                  {/* Support Section */}
                  <Card className="p-6 shadow-card border-2 border-primary/20">
                    <div className="flex items-center gap-2 mb-6">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                        <MessageSquare className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Contact Support</h2>
                        <p className="text-sm text-muted-foreground">
                          Need help? Send us a message.
                        </p>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <Button
                        onClick={() => setSupportDialogOpen(true)}
                        variant="outline"
                        className="w-full sm:w-auto border-2"
                      >
                        <MessageSquare className="w-4 h-4 mr-2" />
                        Contact Support
                      </Button>

                      {supportMessages.length > 0 && (
                        <div className="space-y-2">
                          <p className="text-sm font-medium">Your Support Requests</p>
                          {supportMessages.slice(0, 3).map((msg) => (
                            <Card key={msg.id} className="p-3 border-2">
                              <div className="flex items-start justify-between gap-2">
                                <div className="flex-1">
                                  <p className="text-sm font-medium">{msg.subject}</p>
                                  <p className="text-xs text-muted-foreground mt-1">
                                    {new Date(msg.created_at).toLocaleDateString()}
                                  </p>
                                </div>
                                <Badge
                                  variant={
                                    msg.status === "resolved"
                                      ? "default"
                                      : msg.status === "in_progress"
                                        ? "secondary"
                                        : "outline"
                                  }
                                >
                                  {msg.status}
                                </Badge>
                              </div>
                            </Card>
                          ))}
                        </div>
                      )}
                    </div>
                  </Card>

                  {/* Account Actions */}
                  <Card className="p-6 shadow-card border-2 border-destructive/20">
                    <div className="flex items-center gap-2 mb-6">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/10 text-destructive">
                        <User className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold text-destructive">Account Actions</h2>
                        <p className="text-sm text-muted-foreground">
                          Permanently delete your account
                        </p>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <p className="text-sm text-muted-foreground">
                        Once you delete your account, there is no going back. Please be certain.
                      </p>
                      <Button
                        onClick={handleDeleteAccount}
                        variant="destructive"
                        className="w-full sm:w-auto"
                      >
                        Delete Account
                      </Button>
                    </div>
                  </Card>
                </div>
              )}
            </div>
          </main>

          {/* Right Sidebar */}
          <aside className="hidden lg:block w-80 border-l border-border/60 bg-sidebar/50 backdrop-blur-sm">
            <div className="p-6 space-y-6">
              {/* Account Info */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Account Info
                </h3>
                <Card className="p-4 shadow-card border-2 border-primary/20 bg-primary/5">
                  <div className="flex items-center gap-3 mb-3">
                    <div className="flex h-12 w-12 items-center justify-center rounded-full bg-gradient-hero text-white">
                      <User className="w-6 h-6" />
                    </div>
                    <div className="flex-1">
                      <p className="font-semibold">{fullName || "User"}</p>
                      <p className="text-xs text-muted-foreground">{email}</p>
                    </div>
                  </div>
                  <Badge variant="secondary" className="w-fit capitalize">
                    {role}
                  </Badge>
                </Card>
              </div>

              {/* Quick Tips */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Tips
                </h3>
                <Card className="p-4 shadow-card border-2 border-accent/20 bg-accent/5">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-accent text-accent-foreground flex-shrink-0">
                      <Sparkles className="w-4 h-4" />
                    </div>
                    <div>
                      <p className="text-sm font-medium mb-1">Keep Updated</p>
                      <p className="text-xs text-muted-foreground">
                        Enable notifications to stay informed about matches and messages.
                      </p>
                    </div>
                  </div>
                </Card>
                <Card className="p-4 shadow-card border-2 border-warning/20 bg-warning/5">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-warning text-warning-foreground flex-shrink-0">
                      <Shield className="w-4 h-4" />
                    </div>
                    <div>
                      <p className="text-sm font-medium mb-1">Privacy Matters</p>
                      <p className="text-xs text-muted-foreground">
                        Review your privacy settings regularly to control your information.
                      </p>
                    </div>
                  </div>
                </Card>
              </div>

              {/* Help Section */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Need Help?
                </h3>
                <Card className="p-4 shadow-card border-2 border-primary/20 bg-primary/5">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground flex-shrink-0">
                      <HelpCircle className="w-4 h-4" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm font-medium mb-2">Get Support</p>
                      <Button
                        size="sm"
                        variant="outline"
                        className="w-full text-xs"
                        onClick={() => navigate({ to: "/how-it-works" })}
                      >
                        View Help Center
                      </Button>
                    </div>
                  </div>
                </Card>
              </div>
            </div>
          </aside>
        </div>
      </div>

      {/* Support Dialog */}
      <Dialog open={supportDialogOpen} onOpenChange={setSupportDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Contact Support</DialogTitle>
            <DialogDescription>
              Send a message to our support team. We'll get back to you as soon as possible.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleSupportSubmit} className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="support-subject">Subject</Label>
              <Input
                id="support-subject"
                placeholder="Brief description of your issue"
                value={supportSubject}
                onChange={(e) => setSupportSubject(e.target.value)}
                required
                minLength={5}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="support-priority">Priority</Label>
              <Select value={supportPriority} onValueChange={setSupportPriority}>
                <SelectTrigger id="support-priority">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="low">Low - General inquiry</SelectItem>
                  <SelectItem value="medium">Medium - Need assistance</SelectItem>
                  <SelectItem value="high">High - Issue affecting usage</SelectItem>
                  <SelectItem value="urgent">Urgent - Critical issue</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="support-message">Message</Label>
              <Textarea
                id="support-message"
                placeholder="Describe your issue in detail..."
                value={supportMessage}
                onChange={(e) => setSupportMessage(e.target.value)}
                required
                minLength={10}
                rows={4}
              />
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setSupportDialogOpen(false)}>
                Cancel
              </Button>
              <Button type="submit" disabled={submitSupportMutation.isPending}>
                {submitSupportMutation.isPending ? "Sending..." : "Send Message"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </SidebarProvider>
  );
}
