import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Navbar } from "@/components/Navbar";
import { RoleGate } from "@/components/RoleGate";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { supabase } from "@/integrations/supabase/client";
import { respondToInquiry } from "@/server/inquiry.functions";
import { toast } from "sonner";
import { useRealtimeSubscription } from "@/hooks/useRealtime";
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
  SidebarTrigger,
} from "@/components/ui/sidebar";
import {
  Home,
  MessageSquare,
  History,
  Star,
  Settings as SettingsIcon,
  LayoutDashboard,
  Sparkles,
  Clock,
  TrendingUp,
  HelpCircle,
  FileText,
  CheckCircle,
  XCircle,
  AlertCircle,
} from "lucide-react";

const SERVICE_CATEGORIES = [
  "plumbing",
  "electrical",
  "cleaning",
  "gardening",
  "painting",
  "carpentry",
  "tutoring",
  "moving",
  "appliance_repair",
  "car_mechanic",
  "hair_beauty",
  "it_support",
  "photography",
  "security",
  "catering",
] as const;

export const Route = createFileRoute("/provider")({
  component: () => (
    <RoleGate allow={["provider"]}>
      <ProviderDashboard />
    </RoleGate>
  ),
  head: () => ({ meta: [{ title: "Provider dashboard — MatchWise" }] }),
});

interface Provider {
  id: string;
  business_name: string;
  category: string;
  bio: string | null;
  hourly_rate: number | null;
  location: string | null;
  status: string;
  verification_status: string;
  review_notes: string | null;
  business_registration_number: string | null;
}

interface Doc {
  id: string;
  file_name: string;
  doc_type: string | null;
  status: string;
  created_at: string;
}

interface ProviderInput {
  businessName: string;
  category: string;
  bio: string;
  rate: string;
  location: string;
  businessRegistrationNumber: string;
}

interface IncomingRequest {
  id: string;
  inquiry_message: string | null;
  inquiry_preferred_date: string | null;
  inquiry_requested_at: string | null;
  inquiry_status: "requested" | "accepted" | "declined" | "completed" | "cancelled";
  score: number;
  reason: string | null;
  service_requests: {
    request_text: string;
    location: string | null;
    service_type: string | null;
  } | null;
}

function ProviderDashboard() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [showProfileForm, setShowProfileForm] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>("");

  // Fetch provider profile
  const { data: provider, isLoading: providerLoading } = useQuery({
    queryKey: ["providerProfile"],
    queryFn: async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) return null;
      const { data: p } = await supabase
        .from("service_providers")
        .select("*")
        .eq("user_id", user.id)
        .maybeSingle();
      return p as Provider | null;
    },
  });

  // Update selectedCategory when provider data loads
  useEffect(() => {
    if (provider?.category) {
      setSelectedCategory(provider.category);
    }
  }, [provider?.category]);

  // Fetch documents
  const { data: docs = [], isLoading: docsLoading } = useQuery({
    queryKey: ["providerDocuments", provider?.id],
    queryFn: async () => {
      if (!provider) return [];
      const { data: d } = await supabase
        .from("documents")
        .select("*")
        .eq("provider_id", provider.id)
        .order("created_at", { ascending: false });
      return (d ?? []) as Doc[];
    },
    enabled: !!provider?.id,
  });

  const { data: incoming = [], isLoading: incomingLoading } = useQuery({
    queryKey: ["providerIncoming", provider?.id],
    queryFn: async () => {
      if (!provider) return [];
      console.log("Fetching incoming requests for provider:", provider.id);
      const { data, error } = await supabase
        .from("matches")
        .select(
          `
          id,
          inquiry_message,
          inquiry_preferred_date,
          inquiry_requested_at,
          inquiry_status,
          score,
          reason,
          service_requests (request_text, location, service_type)
        `,
        )
        .eq("provider_id", provider.id)
        .in("inquiry_status", ["requested", "accepted", "declined", "completed", "cancelled"])
        .order("inquiry_requested_at", { ascending: false });

      if (error) {
        console.error("Error fetching incoming requests:", error);
        return [];
      }

      console.log("Incoming requests:", data);
      return (data ?? []) as IncomingRequest[];
    },
    enabled: !!provider,
  });

  // Real-time subscription for matches (updates inquiry status)
  useRealtimeSubscription({
    table: "matches",
    onUpdate: () => {
      queryClient.invalidateQueries({ queryKey: ["providerIncoming"] });
    },
    enabled: !!provider?.id,
  });

  // Real-time subscription for documents (updates document status)
  useRealtimeSubscription({
    table: "documents",
    onInsert: () => {
      queryClient.invalidateQueries({ queryKey: ["providerDocuments"] });
    },
    onUpdate: () => {
      queryClient.invalidateQueries({ queryKey: ["providerDocuments"] });
    },
    enabled: !!provider?.id,
  });

  const respondMutation = useMutation({
    mutationFn: async ({
      matchId,
      action,
    }: {
      matchId: string;
      action: "accepted" | "declined" | "completed" | "cancelled";
    }) => {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      return respondToInquiry({
        data: { match_id: matchId, action },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
    },
    onSuccess: (_res, variables) => {
      const messages = {
        accepted: "Request accepted",
        declined: "Request declined",
        completed: "Request marked as completed",
        cancelled: "Request cancelled",
      };
      toast.success(messages[variables.action]);
      queryClient.invalidateQueries({ queryKey: ["providerIncoming"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to respond");
    },
  });

  // Profile save mutation with optimistic update
  const saveMutation = useMutation({
    mutationFn: async (input: ProviderInput) => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Not authenticated");
      const payload = {
        user_id: user.id,
        business_name: input.businessName,
        category: input.category,
        bio: input.bio || null,
        hourly_rate: input.rate ? parseFloat(input.rate) : null,
        location: input.location || null,
        business_registration_number: input.businessRegistrationNumber || null,
        ...(provider && docs.length > 0 ? { verification_status: "pending" as const } : {}),
      };
      const { error } = provider
        ? await supabase.from("service_providers").update(payload).eq("id", provider.id)
        : await supabase.from("service_providers").insert(payload);
      if (error) throw error;
      return payload;
    },
    onMutate: async (input) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ["providerProfile"] });
      // Snapshot previous value
      const previousProvider = queryClient.getQueryData<Provider>(["providerProfile"]);
      // Optimistically update
      queryClient.setQueryData(["providerProfile"], (old: Provider | null) => {
        if (!old) return old;
        return {
          ...old,
          business_name: input.businessName,
          category: input.category,
          bio: input.bio || null,
          hourly_rate: input.rate ? parseFloat(input.rate) : null,
          location: input.location || null,
          business_registration_number: input.businessRegistrationNumber || null,
          ...(docs.length > 0 ? { verification_status: "pending" } : {}),
        };
      });
      return { previousProvider };
    },
    onError: (err, _variables, context) => {
      // Rollback on error
      if (context?.previousProvider) {
        queryClient.setQueryData(["providerProfile"], context.previousProvider);
      }
      toast.error(err instanceof Error ? err.message : "Failed to save");
    },
    onSuccess: (_data, _variables, context) => {
      const wasUpdate = !!context?.previousProvider;
      if (wasUpdate) {
        if (docs.length > 0) {
          toast.success("Profile saved — verification reset to pending review");
        } else {
          toast.success("Profile saved — upload documents to complete verification");
        }
      } else {
        toast.success("Profile created — upload documents to complete verification");
      }
      // Refetch to ensure server state matches
      queryClient.invalidateQueries({ queryKey: ["providerProfile"] });
    },
  });

  // Document upload mutation
  const uploadMutation = useMutation({
    mutationFn: async (file: File) => {
      if (!provider) throw new Error("Please create your profile first before uploading documents");
      if (file.size > 10 * 1024 * 1024) throw new Error("Max 10MB");
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Not authenticated");
      const path = `${user.id}/${Date.now()}-${file.name}`;
      const { error: upErr } = await supabase.storage.from("provider-documents").upload(path, file);
      if (upErr) throw upErr;
      const { error: dbErr } = await supabase.from("documents").insert({
        provider_id: provider.id,
        file_path: path,
        file_name: file.name,
        doc_type: file.type,
      });
      if (dbErr) throw dbErr;

      // Reset verification status to pending when documents are uploaded
      const { error: updateErr } = await supabase
        .from("service_providers")
        .update({ verification_status: "pending" })
        .eq("id", provider.id);

      if (updateErr) console.error("Failed to update verification status:", updateErr);

      return file.name;
    },
    onSuccess: () => {
      toast.success("Document uploaded for verification");
      queryClient.invalidateQueries({ queryKey: ["providerDocuments"] });
      queryClient.invalidateQueries({ queryKey: ["providerProfile"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Upload failed");
    },
  });

  const save = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const form = e.currentTarget;
    const formData = new FormData(form);
    if (!selectedCategory) {
      toast.error("Please select a category");
      return;
    }
    saveMutation.mutate({
      businessName: formData.get("businessName") as string,
      category: selectedCategory,
      bio: formData.get("bio") as string,
      rate: formData.get("rate") as string,
      location: formData.get("location") as string,
      businessRegistrationNumber: formData.get("businessRegistrationNumber") as string,
    });
  };

  const upload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    uploadMutation.mutate(file);
    e.target.value = "";
  };

  const verifyBadge = (s: string) => {
    if (s === "verified" || s === "approved")
      return <Badge className="bg-success text-success-foreground">Verified</Badge>;
    if (s === "rejected") return <Badge variant="destructive">Rejected</Badge>;
    return <Badge variant="secondary">Pending review</Badge>;
  };

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
                      <SidebarMenuButton isActive>
                        <LayoutDashboard className="w-4 h-4" />
                        <span>Provider Dashboard</span>
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
                <SidebarGroupLabel>Quick Actions</SidebarGroupLabel>
                <SidebarGroupContent>
                  <SidebarMenu>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => setShowProfileForm(!showProfileForm)}>
                        <FileText className="w-4 h-4" />
                        <span>Edit Profile</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onClick={() => {
                          const newRequestsSection = document.getElementById("new-requests");
                          newRequestsSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <AlertCircle className="w-4 h-4" />
                        <span>New Requests</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onClick={() => {
                          const inProgressSection = document.getElementById("in-progress");
                          inProgressSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <Clock className="w-4 h-4" />
                        <span>In Progress</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onClick={() => {
                          const completedSection = document.getElementById("completed");
                          completedSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <CheckCircle className="w-4 h-4" />
                        <span>Completed</span>
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
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: "/settings" })}>
                        <SettingsIcon className="w-4 h-4" />
                        <span>Settings</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  </SidebarMenu>
                </SidebarGroupContent>
              </SidebarGroup>
            </SidebarContent>

            <SidebarFooter className="border-t border-border/60 bg-sidebar">
              <div className="p-4">
                <div className="rounded-lg bg-gradient-hero p-3 text-white">
                  <div className="flex items-center gap-2 mb-2">
                    <TrendingUp className="w-4 h-4" />
                    <span className="text-sm font-semibold">Request Stats</span>
                  </div>
                  <div className="space-y-1 text-xs">
                    <div className="flex justify-between">
                      <span className="opacity-80">New:</span>
                      <span className="font-medium">
                        {incoming.filter((req) => req.inquiry_status === "requested").length}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">In Progress:</span>
                      <span className="font-medium">
                        {incoming.filter((req) => req.inquiry_status === "accepted").length}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">Completed:</span>
                      <span className="font-medium">
                        {incoming.filter((req) => req.inquiry_status === "completed").length}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </SidebarFooter>
          </Sidebar>

          {/* Main Content Area */}
          <main className="flex-1 overflow-auto">
            <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6 sm:py-8">
              <div className="mb-6 sm:mb-8">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <SidebarTrigger className="lg:hidden" />
                    <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-hero text-white shadow-lg">
                      <Sparkles className="w-5 h-5" />
                    </div>
                    <div className="flex-1">
                      <h1 className="text-2xl sm:text-3xl font-bold tracking-tight">
                        Provider workspace
                      </h1>
                      <p className="text-sm sm:text-base text-muted-foreground">
                        Manage your profile and verification documents.
                      </p>
                    </div>
                  </div>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => setShowProfileForm(!showProfileForm)}
                    className="border-2"
                  >
                    {showProfileForm ? "Hide Form" : "Show Form"}
                  </Button>
                </div>
              </div>

              {/* Show rejection message if status is rejected */}
              {provider?.verification_status === "rejected" && provider?.review_notes && (
                <Card className="mb-6 p-4 border-2 border-destructive bg-destructive/10 shadow-card">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive text-destructive-foreground flex-shrink-0">
                      <XCircle className="w-4 h-4" />
                    </div>
                    <div className="flex-1">
                      <h3 className="font-semibold text-destructive">Profile Rejected</h3>
                      <p className="mt-1 text-sm text-destructive/80">
                        <span className="font-medium">Reason:</span> {provider.review_notes}
                      </p>
                    </div>
                  </div>
                </Card>
              )}

              {showProfileForm && (
                <Card
                  id="profile-section"
                  className="p-6 shadow-card border-2 border-primary/20 fade-in"
                >
                  <div className="mb-4 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                        <FileText className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Profile & Verification</h2>
                        <p className="text-sm text-muted-foreground">
                          Complete your profile and upload documents for verification.
                        </p>
                      </div>
                    </div>
                    {provider && verifyBadge(provider.verification_status)}
                  </div>

                  <form onSubmit={save} className="grid gap-4 md:grid-cols-2">
                    <div className="space-y-1.5 md:col-span-2">
                      <Label htmlFor="bn" className="font-semibold">
                        Business name
                      </Label>
                      <Input
                        id="bn"
                        name="businessName"
                        required
                        defaultValue={provider?.business_name ?? ""}
                        className="border-2"
                      />
                    </div>
                    <div className="space-y-1.5 md:col-span-2">
                      <Label htmlFor="brn" className="font-semibold">
                        Business registration number (required)
                      </Label>
                      <Input
                        id="brn"
                        name="businessRegistrationNumber"
                        required
                        defaultValue={provider?.business_registration_number ?? ""}
                        className="border-2"
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="cat" className="font-semibold">
                        Category
                      </Label>
                      <Select value={selectedCategory} onValueChange={setSelectedCategory} required>
                        <SelectTrigger id="cat" className="border-2">
                          <SelectValue placeholder="Select a category" />
                        </SelectTrigger>
                        <SelectContent>
                          {SERVICE_CATEGORIES.map((cat) => (
                            <SelectItem key={cat} value={cat}>
                              {cat.charAt(0).toUpperCase() + cat.slice(1).replace(/_/g, " ")}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="loc" className="font-semibold">
                        Location
                      </Label>
                      <Input
                        id="loc"
                        name="location"
                        defaultValue={provider?.location ?? ""}
                        className="border-2"
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="rate" className="font-semibold">
                        Hourly rate (R)
                      </Label>
                      <Input
                        id="rate"
                        name="rate"
                        type="number"
                        step="0.01"
                        defaultValue={provider?.hourly_rate ?? ""}
                        className="border-2"
                      />
                    </div>
                    <div className="space-y-1.5 md:col-span-2">
                      <Label htmlFor="bio" className="font-semibold">
                        Bio
                      </Label>
                      <Textarea
                        id="bio"
                        name="bio"
                        rows={3}
                        defaultValue={provider?.bio ?? ""}
                        className="resize-none border-2"
                      />
                    </div>

                    {/* Document Upload Section */}
                    <div className="md:col-span-2 space-y-3">
                      <div className="flex items-center justify-between">
                        <Label htmlFor="docs" className="font-semibold">
                          Verification documents
                        </Label>
                        <Button
                          asChild
                          variant="outline"
                          size="sm"
                          disabled={uploadMutation.isPending || !provider}
                          className="border-2"
                        >
                          <label className="cursor-pointer">
                            {uploadMutation.isPending ? "Uploading…" : "Upload document"}
                            <input
                              type="file"
                              id="docs"
                              className="hidden"
                              onChange={upload}
                              accept="image/*,application/pdf"
                              disabled={!provider}
                            />
                          </label>
                        </Button>
                      </div>
                      <p className="text-xs text-muted-foreground">
                        Upload IDs, certificates, or business registration documents.
                      </p>

                      {!provider ? (
                        <div className="rounded-lg border-2 border-dashed border-border p-4 text-center bg-muted/30">
                          <p className="text-sm text-muted-foreground">
                            Create your profile first to upload documents
                          </p>
                        </div>
                      ) : docs.length === 0 ? (
                        <div className="rounded-lg border-2 border-dashed border-border p-4 text-center bg-muted/30">
                          <p className="text-sm text-muted-foreground">No documents uploaded yet</p>
                        </div>
                      ) : (
                        <div className="space-y-2">
                          {docs.map((d) => (
                            <div
                              key={d.id}
                              className="flex items-center justify-between rounded-lg border-2 border-border bg-background/50 p-3"
                            >
                              <div className="flex items-center gap-3">
                                <FileText className="w-4 h-4 text-muted-foreground" />
                                <span className="text-sm font-medium">{d.file_name}</span>
                              </div>
                              {verifyBadge(d.status)}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>

                    <div className="md:col-span-2">
                      <Button
                        type="submit"
                        disabled={saveMutation.isPending}
                        className="bg-gradient-hero text-white shadow-lg hover:shadow-xl transition-all w-full sm:w-auto"
                      >
                        {saveMutation.isPending
                          ? "Saving…"
                          : provider
                            ? "Update profile"
                            : "Create profile"}
                      </Button>
                    </div>
                  </form>
                </Card>
              )}

              {provider && (
                <>
                  {/* New Requests Section */}
                  <Card
                    id="new-requests"
                    className="mt-6 p-6 shadow-card border-2 border-transparent hover:border-warning/20 transition-smooth fade-in"
                  >
                    <div className="flex items-center gap-2 mb-4">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-warning text-warning-foreground">
                        <AlertCircle className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">New Requests</h2>
                        <p className="text-sm text-muted-foreground">
                          Clients who matched with you and sent a service request.
                        </p>
                      </div>
                    </div>
                    {incomingLoading ? (
                      <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                        <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                        Loading requests…
                      </div>
                    ) : incoming.filter((req) => req.inquiry_status === "requested").length ===
                      0 ? (
                      <Card className="p-8 text-center text-sm text-muted-foreground shadow-card border-0 bg-muted/30">
                        <div className="flex flex-col items-center gap-3">
                          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                            <AlertCircle className="w-6 h-6 text-muted-foreground" />
                          </div>
                          <p>No new requests.</p>
                        </div>
                      </Card>
                    ) : (
                      <div className="space-y-3">
                        {incoming
                          .filter((req) => req.inquiry_status === "requested")
                          .map((req) => (
                            <Card
                              key={req.id}
                              className="p-4 shadow-card border-2 border-transparent hover:border-warning/20 transition-smooth"
                            >
                              <div className="flex flex-wrap items-start justify-between gap-3">
                                <div className="flex-1">
                                  <p className="text-sm font-medium mb-2">
                                    {req.service_requests?.request_text}
                                  </p>
                                  {req.service_requests?.service_type && (
                                    <Badge variant="outline" className="mb-2">
                                      {req.service_requests.service_type}
                                    </Badge>
                                  )}
                                  {req.inquiry_message && (
                                    <p className="text-sm text-muted-foreground mb-2">
                                      <span className="font-medium text-foreground">Message:</span>{" "}
                                      {req.inquiry_message}
                                    </p>
                                  )}
                                  <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
                                    {req.service_requests?.location && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📍</span>{" "}
                                        {req.service_requests.location}
                                      </span>
                                    )}
                                    {req.inquiry_preferred_date && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📅</span>{" "}
                                        {req.inquiry_preferred_date}
                                      </span>
                                    )}
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">🎯</span>{" "}
                                      {Math.round(req.score)}% match
                                    </span>
                                  </div>
                                </div>
                                <div className="flex items-center gap-2">
                                  <Button
                                    size="sm"
                                    className="bg-gradient-hero text-white shadow-md hover:shadow-lg transition-all"
                                    disabled={respondMutation.isPending}
                                    onClick={() =>
                                      respondMutation.mutate({
                                        matchId: req.id,
                                        action: "accepted",
                                      })
                                    }
                                  >
                                    Accept
                                  </Button>
                                  <Button
                                    size="sm"
                                    variant="outline"
                                    disabled={respondMutation.isPending}
                                    onClick={() =>
                                      respondMutation.mutate({
                                        matchId: req.id,
                                        action: "declined",
                                      })
                                    }
                                    className="border-2"
                                  >
                                    Decline
                                  </Button>
                                </div>
                              </div>
                            </Card>
                          ))}
                      </div>
                    )}
                  </Card>

                  {/* In Progress Section */}
                  <Card
                    id="in-progress"
                    className="mt-6 p-6 shadow-card border-2 border-transparent hover:border-success/20 transition-smooth fade-in"
                  >
                    <div className="flex items-center gap-2 mb-4">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-success text-success-foreground">
                        <Clock className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">In Progress</h2>
                        <p className="text-sm text-muted-foreground">
                          Requests you have accepted and are currently working on.
                        </p>
                      </div>
                    </div>
                    {incomingLoading ? (
                      <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                        <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                        Loading requests…
                      </div>
                    ) : incoming.filter((req) => req.inquiry_status === "accepted").length === 0 ? (
                      <Card className="p-8 text-center text-sm text-muted-foreground shadow-card border-0 bg-muted/30">
                        <div className="flex flex-col items-center gap-3">
                          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                            <Clock className="w-6 h-6 text-muted-foreground" />
                          </div>
                          <p>No requests in progress.</p>
                        </div>
                      </Card>
                    ) : (
                      <div className="space-y-3">
                        {incoming
                          .filter((req) => req.inquiry_status === "accepted")
                          .map((req) => (
                            <Card
                              key={req.id}
                              className="p-4 shadow-card border-2 border-transparent hover:border-success/20 transition-smooth"
                            >
                              <div className="flex flex-wrap items-start justify-between gap-3">
                                <div className="flex-1">
                                  <p className="text-sm font-medium mb-2">
                                    {req.service_requests?.request_text}
                                  </p>
                                  {req.service_requests?.service_type && (
                                    <Badge variant="outline" className="mb-2">
                                      {req.service_requests.service_type}
                                    </Badge>
                                  )}
                                  {req.inquiry_message && (
                                    <p className="text-sm text-muted-foreground mb-2">
                                      <span className="font-medium text-foreground">Message:</span>{" "}
                                      {req.inquiry_message}
                                    </p>
                                  )}
                                  <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
                                    {req.service_requests?.location && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📍</span>{" "}
                                        {req.service_requests.location}
                                      </span>
                                    )}
                                    {req.inquiry_preferred_date && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📅</span>{" "}
                                        {req.inquiry_preferred_date}
                                      </span>
                                    )}
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">🎯</span>{" "}
                                      {Math.round(req.score)}% match
                                    </span>
                                  </div>
                                </div>
                                <div className="flex items-center gap-2">
                                  <Badge className="bg-success text-success-foreground">
                                    In Progress
                                  </Badge>
                                  <Button
                                    size="sm"
                                    variant="outline"
                                    onClick={() => {
                                      console.log("Opening chat for match:", req.id);
                                      window.location.href = `/chat/${req.id}`;
                                    }}
                                    className="border-2"
                                  >
                                    <MessageSquare className="w-4 h-4 mr-1" />
                                    Chat
                                  </Button>
                                  <Button
                                    size="sm"
                                    disabled={respondMutation.isPending}
                                    onClick={() =>
                                      respondMutation.mutate({
                                        matchId: req.id,
                                        action: "completed",
                                      })
                                    }
                                    className="bg-gradient-hero text-white shadow-md hover:shadow-lg transition-all"
                                  >
                                    Complete
                                  </Button>
                                  <Button
                                    size="sm"
                                    variant="destructive"
                                    disabled={respondMutation.isPending}
                                    onClick={() =>
                                      respondMutation.mutate({
                                        matchId: req.id,
                                        action: "cancelled",
                                      })
                                    }
                                  >
                                    Cancel
                                  </Button>
                                </div>
                              </div>
                            </Card>
                          ))}
                      </div>
                    )}
                  </Card>

                  {/* Completed Section */}
                  <Card
                    id="completed"
                    className="mt-6 p-6 shadow-card border-2 border-transparent hover:border-primary/20 transition-smooth fade-in"
                  >
                    <div className="flex items-center gap-2 mb-4">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                        <CheckCircle className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Completed</h2>
                        <p className="text-sm text-muted-foreground">
                          Requests that have been completed.
                        </p>
                      </div>
                    </div>
                    {incomingLoading ? (
                      <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                        <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                        Loading requests…
                      </div>
                    ) : incoming.filter((req) => req.inquiry_status === "completed").length ===
                      0 ? (
                      <Card className="p-8 text-center text-sm text-muted-foreground shadow-card border-0 bg-muted/30">
                        <div className="flex flex-col items-center gap-3">
                          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                            <CheckCircle className="w-6 h-6 text-muted-foreground" />
                          </div>
                          <p>No completed requests.</p>
                        </div>
                      </Card>
                    ) : (
                      <div className="space-y-3">
                        {incoming
                          .filter((req) => req.inquiry_status === "completed")
                          .map((req) => (
                            <Card
                              key={req.id}
                              className="p-4 shadow-card border-2 border-transparent hover:border-primary/20 transition-smooth"
                            >
                              <div className="flex flex-wrap items-start justify-between gap-3">
                                <div className="flex-1">
                                  <p className="text-sm font-medium mb-2">
                                    {req.service_requests?.request_text}
                                  </p>
                                  {req.service_requests?.service_type && (
                                    <Badge variant="outline" className="mb-2">
                                      {req.service_requests.service_type}
                                    </Badge>
                                  )}
                                  {req.inquiry_message && (
                                    <p className="text-sm text-muted-foreground mb-2">
                                      <span className="font-medium text-foreground">Message:</span>{" "}
                                      {req.inquiry_message}
                                    </p>
                                  )}
                                  <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
                                    {req.service_requests?.location && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📍</span>{" "}
                                        {req.service_requests.location}
                                      </span>
                                    )}
                                    {req.inquiry_preferred_date && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📅</span>{" "}
                                        {req.inquiry_preferred_date}
                                      </span>
                                    )}
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">🎯</span>{" "}
                                      {Math.round(req.score)}% match
                                    </span>
                                  </div>
                                </div>
                                <div className="flex items-center gap-2">
                                  <Badge className="bg-success text-success-foreground">
                                    Completed
                                  </Badge>
                                </div>
                              </div>
                            </Card>
                          ))}
                      </div>
                    )}
                  </Card>

                  {/* Cancelled Section */}
                  <Card className="mt-6 p-6 shadow-card border-2 border-transparent hover:border-destructive/20 transition-smooth fade-in">
                    <div className="flex items-center gap-2 mb-4">
                      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive text-destructive-foreground">
                        <XCircle className="w-4 h-4" />
                      </div>
                      <div>
                        <h2 className="text-lg font-semibold">Cancelled</h2>
                        <p className="text-sm text-muted-foreground">
                          Requests that were declined or cancelled.
                        </p>
                      </div>
                    </div>
                    {incomingLoading ? (
                      <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                        <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                        Loading requests…
                      </div>
                    ) : incoming.filter(
                        (req) =>
                          req.inquiry_status === "declined" || req.inquiry_status === "cancelled",
                      ).length === 0 ? (
                      <Card className="p-8 text-center text-sm text-muted-foreground shadow-card border-0 bg-muted/30">
                        <div className="flex flex-col items-center gap-3">
                          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                            <XCircle className="w-6 h-6 text-muted-foreground" />
                          </div>
                          <p>No cancelled requests.</p>
                        </div>
                      </Card>
                    ) : (
                      <div className="space-y-3">
                        {incoming
                          .filter(
                            (req) =>
                              req.inquiry_status === "declined" ||
                              req.inquiry_status === "cancelled",
                          )
                          .map((req) => (
                            <Card
                              key={req.id}
                              className="p-4 shadow-card border-2 border-transparent hover:border-destructive/20 transition-smooth"
                            >
                              <div className="flex flex-wrap items-start justify-between gap-3">
                                <div className="flex-1">
                                  <p className="text-sm font-medium mb-2">
                                    {req.service_requests?.request_text}
                                  </p>
                                  {req.service_requests?.service_type && (
                                    <Badge variant="outline" className="mb-2">
                                      {req.service_requests.service_type}
                                    </Badge>
                                  )}
                                  {req.inquiry_message && (
                                    <p className="text-sm text-muted-foreground mb-2">
                                      <span className="font-medium text-foreground">Message:</span>{" "}
                                      {req.inquiry_message}
                                    </p>
                                  )}
                                  <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
                                    {req.service_requests?.location && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📍</span>{" "}
                                        {req.service_requests.location}
                                      </span>
                                    )}
                                    {req.inquiry_preferred_date && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📅</span>{" "}
                                        {req.inquiry_preferred_date}
                                      </span>
                                    )}
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">🎯</span>{" "}
                                      {Math.round(req.score)}% match
                                    </span>
                                  </div>
                                </div>
                                <div className="flex items-center gap-2">
                                  <Badge variant="secondary">
                                    {req.inquiry_status === "declined" ? "Declined" : "Cancelled"}
                                  </Badge>
                                </div>
                              </div>
                            </Card>
                          ))}
                      </div>
                    )}
                  </Card>
                </>
              )}
            </div>
          </main>

          {/* Right Sidebar */}
          <aside className="hidden lg:block w-80 border-l border-border/60 bg-sidebar/50 backdrop-blur-sm">
            <div className="p-6 space-y-6">
              {/* Provider Stats */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Request Stats
                </h3>
                <div className="grid grid-cols-2 gap-3">
                  <Card className="p-4 text-center shadow-card border-2 border-warning/20">
                    <div className="text-2xl font-bold text-warning">
                      {incoming.filter((req) => req.inquiry_status === "requested").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">New</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-success/20">
                    <div className="text-2xl font-bold text-success">
                      {incoming.filter((req) => req.inquiry_status === "accepted").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">In Progress</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-primary/20">
                    <div className="text-2xl font-bold text-primary">
                      {incoming.filter((req) => req.inquiry_status === "completed").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">Completed</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-destructive/20">
                    <div className="text-2xl font-bold text-destructive">
                      {
                        incoming.filter(
                          (req) =>
                            req.inquiry_status === "declined" || req.inquiry_status === "cancelled",
                        ).length
                      }
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">Cancelled</div>
                  </Card>
                </div>
              </div>

              {/* Verification Status */}
              {provider && (
                <div className="space-y-4">
                  <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                    Verification Status
                  </h3>
                  <Card className="p-4 shadow-card border-2 border-primary/20 bg-primary/5">
                    <div className="flex items-center gap-3">
                      <div
                        className={`flex h-10 w-10 items-center justify-center rounded-full ${
                          provider.verification_status === "verified" ||
                          provider.verification_status === "approved"
                            ? "bg-success/20 text-success"
                            : provider.verification_status === "rejected"
                              ? "bg-destructive/20 text-destructive"
                              : "bg-warning/20 text-warning"
                        }`}
                      >
                        {provider.verification_status === "verified" ||
                        provider.verification_status === "approved" ? (
                          <CheckCircle className="w-5 h-5" />
                        ) : provider.verification_status === "rejected" ? (
                          <XCircle className="w-5 h-5" />
                        ) : (
                          <Clock className="w-5 h-5" />
                        )}
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-semibold capitalize">
                          {provider.verification_status}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {docs.length} document{docs.length !== 1 ? "s" : ""} uploaded
                        </p>
                      </div>
                    </div>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => setShowProfileForm(!showProfileForm)}
                      className="w-full mt-3 border-2"
                    >
                      {showProfileForm ? "Hide Profile Form" : "Edit Profile"}
                    </Button>
                  </Card>
                </div>
              )}

              {/* Tips */}
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
                      <p className="text-sm font-medium mb-1">Complete Profile</p>
                      <p className="text-xs text-muted-foreground">
                        Keep your profile updated with accurate information to attract more clients.
                      </p>
                    </div>
                  </div>
                </Card>
                <Card className="p-4 shadow-card border-2 border-success/20 bg-success/5">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-success text-success-foreground flex-shrink-0">
                      <TrendingUp className="w-4 h-4" />
                    </div>
                    <div>
                      <p className="text-sm font-medium mb-1">Respond Quickly</p>
                      <p className="text-xs text-muted-foreground">
                        Fast responses to new requests can increase your chances of getting hired.
                      </p>
                    </div>
                  </div>
                </Card>
              </div>

              {/* Recent Activity */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Recent Activity
                </h3>
                {incoming.length > 0 ? (
                  <div className="space-y-2">
                    {incoming.slice(0, 3).map((request) => (
                      <Card key={request.id} className="p-3 shadow-card border border-border/60">
                        <div className="flex items-start gap-2">
                          <div
                            className={`flex h-6 w-6 items-center justify-center rounded-full flex-shrink-0 ${
                              request.inquiry_status === "accepted"
                                ? "bg-success/20 text-success"
                                : request.inquiry_status === "completed"
                                  ? "bg-primary/20 text-primary"
                                  : request.inquiry_status === "declined" ||
                                      request.inquiry_status === "cancelled"
                                    ? "bg-destructive/20 text-destructive"
                                    : "bg-warning/20 text-warning"
                            }`}
                          >
                            {request.inquiry_status === "accepted"
                              ? "✓"
                              : request.inquiry_status === "completed"
                                ? "★"
                                : request.inquiry_status === "declined" ||
                                    request.inquiry_status === "cancelled"
                                  ? "✕"
                                  : "!"}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-medium truncate">
                              {request.service_requests?.request_text}
                            </p>
                            <p className="text-xs text-muted-foreground mt-1 capitalize">
                              {request.inquiry_status}
                            </p>
                          </div>
                        </div>
                      </Card>
                    ))}
                  </div>
                ) : (
                  <Card className="p-4 text-center text-sm text-muted-foreground shadow-card">
                    <p>No recent activity yet.</p>
                  </Card>
                )}
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
                        onClick={() => navigate({ to: "/settings" })}
                      >
                        Contact Support
                      </Button>
                    </div>
                  </div>
                </Card>
              </div>
            </div>
          </aside>
        </div>
      </div>
    </SidebarProvider>
  );
}
