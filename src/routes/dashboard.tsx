import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Navbar } from "@/components/Navbar";
import { RoleGate } from "@/components/RoleGate";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription,
} from "@/components/ui/dialog";
import { matchRequest } from "@/server/match.functions";
import { ProviderInquiryDialog } from "@/components/ProviderInquiryDialog";
import { FavoriteProviderRequestDialog } from "@/components/FavoriteProviderRequestDialog";
import { OnboardingDialog } from "@/components/OnboardingDialog";
import { createProviderReport } from "@/server/report.functions";
import { submitRating } from "@/server/rating.functions";
import {
  addFavoriteProvider,
  removeFavoriteProvider,
  isProviderFavorited,
  getFavoriteProviders,
} from "@/server/favorite.functions";
import { supabase } from "@/integrations/supabase/client";
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
  Heart,
  Settings as SettingsIcon,
  LayoutDashboard,
  Sparkles,
  Clock,
  TrendingUp,
  HelpCircle,
  CheckCircle,
  Mic,
  MicOff,
  ChevronDown,
  XCircle,
} from "lucide-react";

export const Route = createFileRoute("/dashboard")({
  component: () => (
    <RoleGate allow={["client"]}>
      <ClientDashboard />
    </RoleGate>
  ),
  head: () => ({ meta: [{ title: "Client dashboard — MatchWise" }] }),
});

interface MatchResult {
  match_id: string;
  provider_id: string;
  score: number;
  reason: string;
  provider: {
    id: string;
    business_name: string;
    category: string;
    location: string | null;
    avg_rating: number | null;
    rating_count: number | null;
    hourly_rate: number | null;
    bio?: string | null;
  };
}

interface PastRequest {
  id: string;
  request_text: string;
  service_type: string | null;
  ai_summary: string | null;
  status: string;
  created_at: string;
}

interface ClientMatch {
  id: string;
  request_id: string;
  provider_id: string;
  score: number;
  reason: string;
  inquiry_status: string | null;
  status: string | null;
  created_at: string;
  has_rated?: boolean;
  is_favorited?: boolean;
  service_request?: {
    id: string;
    request_text: string;
    client_id: string;
    status: string;
  };
  provider?: {
    id: string;
    business_name: string;
    category: string;
    location: string | null;
    avg_rating: number | null;
    rating_count: number | null;
    hourly_rate: number | null;
  } | null;
}

const PAST_REQUESTS_PAGE_SIZE = 5;

// Helper function to filter out active and completed requests from recent requests
const filterRecentRequests = (
  allRequests: PastRequest[],
  clientMatches: ClientMatch[],
): PastRequest[] => {
  const activeRequestIds = new Set(
    clientMatches
      .filter((m) => m.inquiry_status === "accepted" || m.inquiry_status === "completed")
      .map((m) => m.service_request?.id)
      .filter(Boolean),
  );

  return allRequests.filter((r) => !activeRequestIds.has(r.id));
};

function ClientDashboard() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [text, setText] = useState("");
  const [loc, setLoc] = useState("");
  const [result, setResult] = useState<{ summary?: string; matches: MatchResult[] } | null>(null);
  const [pastPage, setPastPage] = useState(0);
  const [requestedIds, setRequestedIds] = useState<Set<string>>(new Set());
  const [inquiryTarget, setInquiryTarget] = useState<MatchResult | null>(null);
  const [reportDialogOpen, setReportDialogOpen] = useState(false);
  const [reportingMatch, setReportingMatch] = useState<ClientMatch | null>(null);
  const [reportText, setReportText] = useState("");
  const [cancelDialogOpen, setCancelDialogOpen] = useState(false);
  const [cancellingRequest, setCancellingRequest] = useState<PastRequest | null>(null);
  const [cancelMatchDialogOpen, setCancelMatchDialogOpen] = useState(false);
  const [cancellingMatch, setCancellingMatch] = useState<ClientMatch | null>(null);
  const [ratingDialogOpen, setRatingDialogOpen] = useState(false);
  const [ratingMatch, setRatingMatch] = useState<ClientMatch | null>(null);
  const [rating, setRating] = useState(0);
  const [ratingComment, setRatingComment] = useState("");
  const [favoriteRequestDialogOpen, setFavoriteRequestDialogOpen] = useState(false);
  const [favoriteRequestTarget, setFavoriteRequestTarget] = useState<{
    id: string;
    name: string;
  } | null>(null);
  const [showRequestHistory, setShowRequestHistory] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [recognition, setRecognition] = useState<SpeechRecognition | null>(null);
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [showMobileStats, setShowMobileStats] = useState(false);
  const searchFormRef = useRef<HTMLDivElement>(null);

  // Check if user needs onboarding (disabled - profiles table doesn't have onboarding_completed column)
  // useEffect(() => {
  //   const checkOnboarding = async () => {
  //     const {
  //       data: { user },
  //     } = await supabase.auth.getUser();
  //     if (!user) return;

  //     const { data: profile } = await supabase
  //       .from("profiles")
  //       .select("onboarding_completed")
  //       .eq("id", user.id)
  //       .single();

  //     if (profile && !profile.onboarding_completed) {
  //       setShowOnboarding(true);
  //     }
  //   };

  //   checkOnboarding();
  // }, []);

  // Initialize Web Speech API
  useEffect(() => {
    if (
      typeof window !== "undefined" &&
      ("webkitSpeechRecognition" in window || "SpeechRecognition" in window)
    ) {
      const SpeechRecognitionAPI =
        (
          window as Window & {
            webkitSpeechRecognition?: typeof SpeechRecognition;
            SpeechRecognition?: typeof SpeechRecognition;
          }
        ).webkitSpeechRecognition ||
        (
          window as Window & {
            SpeechRecognition?: typeof SpeechRecognition;
          }
        ).SpeechRecognition;
      if (SpeechRecognitionAPI) {
        const rec = new SpeechRecognitionAPI();
        rec.continuous = true;
        rec.interimResults = true;
        rec.lang = "en-US";

        rec.onresult = (event: SpeechRecognitionEvent) => {
          let interimTranscript = "";
          let finalTranscript = "";

          for (let i = event.resultIndex; i < event.results.length; i++) {
            const transcript = event.results[i][0].transcript;
            if (event.results[i].isFinal) {
              finalTranscript += transcript;
            } else {
              interimTranscript += transcript;
            }
          }

          if (finalTranscript) {
            setText((prev) => prev + finalTranscript);
          }
        };

        rec.onerror = (event: SpeechRecognitionErrorEvent) => {
          console.error("Speech recognition error:", event.error);
          setIsRecording(false);
          if (event.error !== "no-speech") {
            toast.error("Voice recognition error. Please try again.");
          }
        };

        rec.onend = () => {
          setIsRecording(false);
        };

        setRecognition(rec);
      }
    }
  }, []);

  const toggleRecording = () => {
    if (!recognition) {
      toast.error("Voice recognition is not supported in your browser.");
      return;
    }

    if (isRecording) {
      recognition.stop();
      setIsRecording(false);
    } else {
      recognition.start();
      setIsRecording(true);
      toast.info("Listening... Speak now.");
    }
  };

  // Fetch client's accepted matches
  const { data: clientMatches = [], isLoading: matchesLoading } = useQuery({
    queryKey: ["clientMatches"],
    queryFn: async () => {
      const { data: authData } = await supabase.auth.getUser();
      const user = authData?.user;
      if (!user) return [];

      // First get all service request IDs for this user
      const { data: requests } = await supabase
        .from("service_requests")
        .select("id")
        .eq("client_id", user.id);

      if (!requests || requests.length === 0) return [];

      const requestIds = requests.map((r) => r.id);

      // Then get matches for these requests
      const { data: m } = await supabase
        .from("matches")
        .select(
          `
          *,
          provider:service_providers(
            id,
            business_name,
            category,
            location,
            avg_rating,
            rating_count,
            hourly_rate
          ),
          service_request:service_requests(
            id,
            request_text,
            client_id,
            status
          )
        `,
        )
        .in("request_id", requestIds)
        .not("inquiry_status", "is", null)
        .order("inquiry_requested_at", { ascending: false });

      // Check which providers have been rated by this user
      const providerIds = (m ?? []).map((match) => match.provider_id).filter(Boolean);
      const { data: ratings } = await supabase
        .from("ratings")
        .select("provider_id")
        .eq("client_id", user.id)
        .in("provider_id", providerIds);

      const ratedProviderIds = new Set(ratings?.map((r) => r.provider_id) || []);

      // Check which providers are favorited by this user
      const { data: favorites } = await supabase
        .from("favorite_providers")
        .select("provider_id")
        .eq("client_id", user.id)
        .in("provider_id", providerIds);

      const favoritedProviderIds = new Set(favorites?.map((f) => f.provider_id) || []);

      // Ensure all matches have provider info, rating status, and favorite status
      const matchesWithProvider = (m ?? []).map((match) => ({
        ...match,
        provider: match.provider || null,
        has_rated: ratedProviderIds.has(match.provider_id),
        is_favorited: favoritedProviderIds.has(match.provider_id),
      }));

      return matchesWithProvider as ClientMatch[];
    },
  });

  // Fetch all past requests (without pagination for filtering)
  const { data: allPastRequests = [], isLoading: pastLoading } = useQuery({
    queryKey: ["allPastRequests"],
    queryFn: async () => {
      const { data: authData } = await supabase.auth.getUser();
      const user = authData?.user;
      if (!user) return [];
      const { data } = await supabase
        .from("service_requests")
        .select("*")
        .eq("client_id", user.id)
        .order("created_at", { ascending: false });
      return (data ?? []) as PastRequest[];
    },
  });

  // Filter and paginate recent requests
  const recentRequests = filterRecentRequests(allPastRequests, clientMatches);
  const paginatedRecentRequests = recentRequests.slice(
    pastPage * PAST_REQUESTS_PAGE_SIZE,
    (pastPage + 1) * PAST_REQUESTS_PAGE_SIZE,
  );

  // For backwards compatibility
  const past = allPastRequests;

  // Fetch favorite providers
  const { data: favoriteProviders = [], isLoading: favoritesLoading } = useQuery({
    queryKey: ["favoriteProviders"],
    queryFn: async () => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      if (!session) return [];
      const res = await getFavoriteProviders({
        headers: { Authorization: `Bearer ${session.access_token}` },
      });
      return res;
    },
  });

  // Real-time subscription for matches (updates match status)
  useRealtimeSubscription({
    table: "matches",
    onInsert: () => {
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
    onUpdate: () => {
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
  });

  // Real-time subscription for favorite_providers (updates favorites list)
  useRealtimeSubscription({
    table: "favorite_providers",
    onInsert: () => {
      queryClient.invalidateQueries({ queryKey: ["favoriteProviders"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
    onDelete: () => {
      queryClient.invalidateQueries({ queryKey: ["favoriteProviders"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
  });

  // Real-time subscription for service_requests (updates request status)
  useRealtimeSubscription({
    table: "service_requests",
    onUpdate: () => {
      queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
  });

  // Mutation for submitting match requests
  const submitMutation = useMutation({
    mutationFn: async () => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await matchRequest({
        data: { request_text: text, location: loc || null },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: (res) => {
      const validMatches = res.matches.filter((m) => m.score > 0);
      setResult({ summary: res.summary, matches: res.matches });
      if (validMatches.length === 0) toast.info("No verified providers yet — check back soon.");
      else toast.success(`Found ${validMatches.length} matches!`);
      // Invalidate and refetch past requests and client matches
      queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
      setText("");
      setLoc("");
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Matching failed");
    },
  });

  // Mutation for creating provider reports
  const reportMutation = useMutation({
    mutationFn: async () => {
      if (!reportingMatch) throw new Error("No match selected for reporting");
      console.log("Submitting report for match:", reportingMatch);
      console.log("Match ID:", reportingMatch.id);
      console.log("Match data:", JSON.stringify(reportingMatch, null, 2));
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await createProviderReport({
        data: { match_id: reportingMatch.id, report_text: reportText },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Report submitted successfully. Admin will review it.");
      setReportDialogOpen(false);
      setReportText("");
      setReportingMatch(null);
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to submit report");
    },
  });

  // Mutation for cancelling service requests
  const cancelRequestMutation = useMutation({
    mutationFn: async (requestId: string) => {
      const { error } = await supabase
        .from("service_requests")
        .update({ status: "cancelled" })
        .eq("id", requestId);

      if (error) throw error;
      return requestId;
    },
    onSuccess: () => {
      toast.success("Request cancelled successfully");
      setCancelDialogOpen(false);
      setCancellingRequest(null);
      queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to cancel request");
    },
  });

  const handleCancelRequest = (request: PastRequest) => {
    setCancellingRequest(request);
    setCancelDialogOpen(true);
  };

  const confirmCancelRequest = () => {
    if (cancellingRequest) {
      cancelRequestMutation.mutate(cancellingRequest.id);
    }
  };

  // Mutation for cancelling in-progress service requests
  const cancelMatchMutation = useMutation({
    mutationFn: async ({ requestId, matchId }: { requestId: string; matchId: string }) => {
      // Cancel the service request
      const { error: requestError } = await supabase
        .from("service_requests")
        .update({ status: "cancelled" })
        .eq("id", requestId);

      if (requestError) throw requestError;

      // Also update the related match to cancelled status
      const { error: matchError } = await supabase
        .from("matches")
        .update({ inquiry_status: "cancelled" })
        .eq("id", matchId);

      if (matchError) throw matchError;

      return { requestId, matchId };
    },
    onSuccess: () => {
      toast.success("Job cancelled successfully");
      setCancelMatchDialogOpen(false);
      setCancellingMatch(null);
      queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to cancel job");
    },
  });

  const handleCancelMatch = (match: ClientMatch) => {
    setCancellingMatch(match);
    setCancelMatchDialogOpen(true);
  };

  const confirmCancelMatch = () => {
    if (cancellingMatch?.service_request?.id && cancellingMatch?.id) {
      cancelMatchMutation.mutate({
        requestId: cancellingMatch.service_request.id,
        matchId: cancellingMatch.id,
      });
    }
  };

  // Mutation for submitting ratings
  const ratingMutation = useMutation({
    mutationFn: async () => {
      if (!ratingMatch) throw new Error("No match selected for rating");
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await submitRating({
        data: {
          match_id: ratingMatch.id,
          provider_id: ratingMatch.provider_id,
          rating: rating,
          comment: ratingComment,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Rating submitted successfully");
      setRatingDialogOpen(false);
      setRating(0);
      setRatingComment("");
      setRatingMatch(null);
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to submit rating");
    },
  });

  const handleRateProvider = (match: ClientMatch) => {
    setRatingMatch(match);
    setRatingDialogOpen(true);
  };

  // Mutation for adding favorite provider
  const addFavoriteMutation = useMutation({
    mutationFn: async (providerId: string) => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await addFavoriteProvider({
        data: { provider_id: providerId },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Provider added to favorites");
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
      queryClient.invalidateQueries({ queryKey: ["favoriteProviders"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to add to favorites");
    },
  });

  // Mutation for removing favorite provider
  const removeFavoriteMutation = useMutation({
    mutationFn: async (providerId: string) => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await removeFavoriteProvider({
        data: { provider_id: providerId },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Provider removed from favorites");
      queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
      queryClient.invalidateQueries({ queryKey: ["favoriteProviders"] });
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to remove from favorites");
    },
  });

  const StarRating = ({
    value,
    onChange,
    readonly = false,
  }: {
    value: number;
    onChange?: (rating: number) => void;
    readonly?: boolean;
  }) => {
    return (
      <div className="flex gap-1">
        {[1, 2, 3, 4, 5].map((star) => (
          <button
            key={star}
            type="button"
            disabled={readonly}
            onClick={() => onChange && onChange(star)}
            className={`text-2xl transition-colors ${readonly ? "cursor-default" : "cursor-pointer hover:scale-110"} ${
              star <= value ? "text-yellow-400" : "text-gray-300"
            }`}
          >
            ★
          </button>
        ))}
      </div>
    );
  };

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (text.trim().length < 10) {
      toast.error("Tell us a bit more (at least 10 characters).");
      return;
    }
    setResult(null);
    setRequestedIds(new Set());
    submitMutation.mutate();
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
                        <span>Dashboard</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: "/" })}>
                        <Home className="w-4 h-4" />
                        <span>Home</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => navigate({ to: "/providers" })}>
                        <Star className="w-4 h-4" />
                        <span>Browse Providers</span>
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
                      <SidebarMenuButton
                        onClick={() => {
                          const activeSection = document.getElementById("active-requests");
                          activeSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <Clock className="w-4 h-4" />
                        <span>Active Jobs</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onClick={() => {
                          const completedSection = document.getElementById("completed-requests");
                          completedSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <Star className="w-4 h-4" />
                        <span>Completed Jobs</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton
                        onClick={() => {
                          const favoritesSection = document.getElementById("favorite-providers");
                          favoritesSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        <Heart className="w-4 h-4" />
                        <span>Favorite Providers</span>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                    <SidebarMenuItem>
                      <SidebarMenuButton onClick={() => setShowRequestHistory(!showRequestHistory)}>
                        <History className="w-4 h-4" />
                        <span>Request History</span>
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
                      <SidebarMenuButton onClick={() => navigate({ to: "/contact-support" })}>
                        <MessageSquare className="w-4 h-4" />
                        <span>Contact Support</span>
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
                    <span className="text-sm font-semibold">Activity Stats</span>
                  </div>
                  <div className="space-y-1 text-xs">
                    <div className="flex justify-between">
                      <span className="opacity-80">Active Jobs:</span>
                      <span className="font-medium">
                        {clientMatches.filter((m) => m.inquiry_status === "accepted").length}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">Completed:</span>
                      <span className="font-medium">
                        {clientMatches.filter((m) => m.inquiry_status === "completed").length}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">Declined:</span>
                      <span className="font-medium">
                        {clientMatches.filter((m) => m.inquiry_status === "declined").length}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">Favorites:</span>
                      <span className="font-medium">{favoriteProviders.length}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="opacity-80">Total Requests:</span>
                      <span className="font-medium">{allPastRequests.length}</span>
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
                <div className="flex items-center gap-3 mb-4">
                  <SidebarTrigger className="lg:hidden" />
                  <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-hero text-white shadow-lg">
                    <Sparkles className="w-5 h-5" />
                  </div>
                  <div className="flex-1">
                    <h1 className="text-2xl sm:text-3xl font-bold tracking-tight">
                      What do you need help with?
                    </h1>
                    <p className="text-sm sm:text-base text-muted-foreground">
                      Describe it in your own words — our AI will find the best matches.
                    </p>
                  </div>
                </div>
              </div>

              <Card ref={searchFormRef} className="p-6 shadow-soft border-2 border-primary/20 fade-in">
                <form onSubmit={submit} className="space-y-4">
                  <div className="space-y-1.5">
                    <div className="flex items-center justify-between">
                      <Label htmlFor="req" className="text-base font-semibold">
                        Your request
                      </Label>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={toggleRecording}
                        className={
                          isRecording
                            ? "text-red-500 hover:text-red-600"
                            : "text-muted-foreground hover:text-primary"
                        }
                      >
                        {isRecording ? (
                          <MicOff className="w-4 h-4 mr-2" />
                        ) : (
                          <Mic className="w-4 h-4 mr-2" />
                        )}
                        {isRecording ? "Stop Recording" : "Voice Input"}
                      </Button>
                    </div>
                    <Textarea
                      id="req"
                      rows={4}
                      placeholder="e.g. I need a reliable plumber to fix a leaking kitchen tap this weekend in Polokwane."
                      value={text}
                      onChange={(e) => setText(e.target.value)}
                      maxLength={2000}
                      className="resize-none"
                    />
                    <p className="text-xs text-muted-foreground text-right">
                      {text.length}/2000 characters
                    </p>
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="loc" className="text-base font-semibold">
                      Location (optional)
                    </Label>
                    <Input
                      id="loc"
                      placeholder="e.g. Polokwane"
                      value={loc}
                      onChange={(e) => setLoc(e.target.value)}
                      maxLength={120}
                    />
                  </div>
                  <Button
                    type="submit"
                    className="bg-gradient-hero text-white shadow-lg hover:shadow-xl transition-all w-full sm:w-auto"
                    disabled={submitMutation.isPending}
                  >
                    {submitMutation.isPending ? "Matching…" : "Find matches"}
                  </Button>
                </form>
              </Card>

              {result && (
                <section className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-hero text-white">
                      <Sparkles className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">AI matches</h2>
                  </div>
                  {result.summary && (
                    <Card className="mb-4 border-primary/30 bg-primary/5 p-4 shadow-card">
                      <div className="flex items-start gap-2">
                        <Sparkles className="w-4 h-4 text-primary mt-0.5" />
                        <div>
                          <p className="text-sm">
                            <span className="font-semibold">AI summary:</span> {result.summary}
                          </p>
                        </div>
                      </div>
                    </Card>
                  )}
                  <div className="grid gap-4">
                    {result.matches.filter((m) => m.score > 0).length === 0 ? (
                      <Card className="p-8 text-center text-sm text-muted-foreground shadow-card">
                        <div className="flex flex-col items-center gap-3">
                          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                            <Sparkles className="w-6 h-6 text-muted-foreground" />
                          </div>
                          <p className="font-medium">No matches yet</p>
                          <p className="text-xs">
                            Try adding more details or a specific location to get better results.
                          </p>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => {
                              const input = document.getElementById("req") as HTMLTextAreaElement;
                              input?.focus();
                            }}
                          >
                            Edit your request
                          </Button>
                        </div>
                      </Card>
                    ) : (
                      result.matches
                        .filter((m) => m.score > 0)
                        .map((m) => (
                          <Card
                            key={m.provider_id}
                            className="p-6 shadow-card transition-smooth hover:shadow-soft border-2 border-transparent hover:border-primary/20"
                          >
                            <div className="flex items-start justify-between gap-4">
                              <div className="flex-1">
                                <div className="flex items-center gap-2 mb-2">
                                  <h3 className="font-semibold text-lg">
                                    {m.provider.business_name}
                                  </h3>
                                  <Badge variant="secondary" className="font-medium">
                                    {m.provider.category}
                                  </Badge>
                                </div>
                                <p className="text-sm text-muted-foreground mb-3">{m.reason}</p>
                                <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground mb-4">
                                  {m.provider.location && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">📍</span> {m.provider.location}
                                    </span>
                                  )}
                                  <span className="flex items-center gap-1">
                                    <span className="font-medium">⭐</span>{" "}
                                    {(m.provider.avg_rating ?? 0).toFixed(1)} (
                                    {m.provider.rating_count ?? 0})
                                  </span>
                                  {m.provider.hourly_rate && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">💰</span> R
                                      {m.provider.hourly_rate}/hr
                                    </span>
                                  )}
                                </div>
                                <div>
                                  {requestedIds.has(m.match_id) ? (
                                    <Badge className="bg-success text-success-foreground px-3 py-1 text-sm">
                                      Request sent
                                    </Badge>
                                  ) : (
                                    <Button
                                      size="sm"
                                      className="bg-gradient-hero text-white shadow-md hover:shadow-lg transition-all"
                                      onClick={() => setInquiryTarget(m)}
                                    >
                                      Request this provider
                                    </Button>
                                  )}
                                </div>
                              </div>
                              <div className="text-right">
                                <div className="rounded-xl bg-gradient-hero px-4 py-3 text-white shadow-lg">
                                  <div className="text-xs opacity-90 font-medium">Match</div>
                                  <div className="text-2xl font-bold">{Math.round(m.score)}%</div>
                                </div>
                              </div>
                            </div>
                          </Card>
                        ))
                    )}
                  </div>
                </section>
              )}

              {inquiryTarget && (
                <ProviderInquiryDialog
                  open={!!inquiryTarget}
                  onOpenChange={(open) => !open && setInquiryTarget(null)}
                  matchId={inquiryTarget.match_id}
                  providerName={inquiryTarget.provider.business_name}
                  onSuccess={() => {
                    setRequestedIds((prev) => new Set(prev).add(inquiryTarget.match_id));
                    queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
                  }}
                />
              )}

              {favoriteRequestTarget && (
                <FavoriteProviderRequestDialog
                  open={favoriteRequestDialogOpen}
                  onOpenChange={(open) => {
                    setFavoriteRequestDialogOpen(open);
                    if (!open) setFavoriteRequestTarget(null);
                  }}
                  providerId={favoriteRequestTarget.id}
                  providerName={favoriteRequestTarget.name}
                  onSuccess={() => {
                    queryClient.invalidateQueries({ queryKey: ["allPastRequests"] });
                    queryClient.invalidateQueries({ queryKey: ["clientMatches"] });
                  }}
                />
              )}

              {/* Onboarding Dialog */}
              <OnboardingDialog open={showOnboarding} onOpenChange={setShowOnboarding} />

              {/* Report Provider Dialog */}
              <Dialog open={reportDialogOpen} onOpenChange={setReportDialogOpen}>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Report Provider</DialogTitle>
                    <DialogDescription>
                      Report {reportingMatch?.provider?.business_name || "this provider"} to admin.
                      Please provide details about why they became quiet after accepting the job.
                    </DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <Label htmlFor="report-text">Report details</Label>
                      <Textarea
                        id="report-text"
                        placeholder="Describe the issue... (e.g., Provider accepted the job but stopped responding, hasn't shown up, etc.)"
                        value={reportText}
                        onChange={(e) => setReportText(e.target.value)}
                        rows={4}
                        maxLength={1000}
                      />
                      <p className="text-xs text-muted-foreground">
                        {reportText.length}/1000 characters
                      </p>
                    </div>
                  </div>
                  <DialogFooter>
                    <Button
                      variant="outline"
                      onClick={() => {
                        setReportDialogOpen(false);
                        setReportText("");
                        setReportingMatch(null);
                      }}
                    >
                      Cancel
                    </Button>
                    <Button
                      variant="destructive"
                      onClick={() => reportMutation.mutate()}
                      disabled={reportMutation.isPending || reportText.trim().length < 10}
                    >
                      {reportMutation.isPending ? "Submitting..." : "Submit Report"}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {/* Active Matches Section */}
              {(clientMatches.length > 0 || matchesLoading) && (
                <section id="active-requests" className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-success text-success-foreground">
                      <Clock className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">Active Requests</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mb-4">
                    Requests you have sent that providers are currently working on.
                  </p>
                  {matchesLoading ? (
                    <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                      <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                      Loading…
                    </div>
                  ) : clientMatches.filter((m) => m.inquiry_status === "accepted").length === 0 ? (
                    <Card className="p-8 text-center text-sm text-muted-foreground shadow-card">
                      <div className="flex flex-col items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                          <Clock className="w-6 h-6 text-muted-foreground" />
                        </div>
                        <p>
                          No active requests yet. When providers accept your requests, they'll
                          appear here.
                        </p>
                      </div>
                    </Card>
                  ) : (
                    <div className="space-y-3">
                      {clientMatches
                        .filter((m) => m.inquiry_status === "accepted")
                        .map((match) => (
                          <Card
                            key={match.id}
                            className="p-5 shadow-card border-2 border-transparent hover:border-success/20 transition-smooth"
                          >
                            <div className="flex items-start justify-between gap-4">
                              <div className="flex-1">
                                <div className="flex items-center gap-2 mb-2">
                                  <h3 className="font-semibold text-lg">
                                    {match.provider?.business_name || "Unknown"}
                                  </h3>
                                  {match.provider && (
                                    <Badge variant="secondary" className="font-medium">
                                      {match.provider.category}
                                    </Badge>
                                  )}
                                  <Badge className="bg-success text-success-foreground px-2 py-0.5 text-xs font-medium">
                                    Active
                                  </Badge>
                                </div>
                                <p className="text-sm text-muted-foreground mb-3">{match.reason}</p>
                                {match.provider && (
                                  <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground mb-4">
                                    {match.provider.location && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">📍</span>{" "}
                                        {match.provider.location}
                                      </span>
                                    )}
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">⭐</span>{" "}
                                      {(match.provider.avg_rating ?? 0).toFixed(1)} (
                                      {match.provider.rating_count ?? 0})
                                    </span>
                                    {match.provider.hourly_rate && (
                                      <span className="flex items-center gap-1">
                                        <span className="font-medium">💰</span> R
                                        {match.provider.hourly_rate}/hr
                                      </span>
                                    )}
                                  </div>
                                )}
                              </div>
                              <div className="flex flex-col gap-2">
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() => navigate({ to: `/chat/${match.id}` })}
                                  className="bg-gradient-hero text-white border-0"
                                >
                                  <MessageSquare className="w-4 h-4 mr-1" />
                                  Open Chat
                                </Button>
                                {match.is_favorited ? (
                                  <Button
                                    size="sm"
                                    variant="outline"
                                    onClick={() => {
                                      if (match.provider) {
                                        removeFavoriteMutation.mutate(match.provider.id);
                                      }
                                    }}
                                    disabled={removeFavoriteMutation.isPending}
                                    className="text-xs"
                                  >
                                    <Heart className="w-4 h-4 mr-1 fill-red-500 text-red-500" />
                                    Remove from Favorites
                                  </Button>
                                ) : (
                                  <Button
                                    size="sm"
                                    variant="outline"
                                    onClick={() => {
                                      if (match.provider) {
                                        addFavoriteMutation.mutate(match.provider.id);
                                      }
                                    }}
                                    disabled={addFavoriteMutation.isPending}
                                    className="text-xs"
                                  >
                                    <Heart className="w-4 h-4 mr-1" />
                                    Add to Favorites
                                  </Button>
                                )}
                                {match.service_request?.status === "in_progress" && (
                                  <>
                                    <Button
                                      size="sm"
                                      variant="destructive"
                                      onClick={() => handleCancelMatch(match)}
                                      disabled={cancelMatchMutation.isPending}
                                      className="text-xs"
                                    >
                                      Cancel Job
                                    </Button>
                                    <Button
                                      size="sm"
                                      variant="destructive"
                                      onClick={() => {
                                        setReportingMatch(match);
                                        setReportDialogOpen(true);
                                      }}
                                      className="text-xs"
                                    >
                                      Report Provider
                                    </Button>
                                  </>
                                )}
                              </div>
                            </div>
                          </Card>
                        ))}
                    </div>
                  )}
                </section>
              )}

              {/* Completed Matches Section */}
              {clientMatches.filter((m) => m.inquiry_status === "completed").length > 0 && (
                <section id="completed-requests" className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                      <CheckCircle className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">Completed Jobs</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mb-4">
                    Requests that have been completed by providers.
                  </p>
                  <div className="space-y-3">
                    {clientMatches
                      .filter((m) => m.inquiry_status === "completed")
                      .map((match) => (
                        <Card
                          key={match.id}
                          className="p-5 shadow-card border-2 border-transparent hover:border-primary/20 transition-smooth"
                        >
                          <div className="flex items-start justify-between gap-4">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-2">
                                <h3 className="font-semibold text-lg">
                                  {match.provider?.business_name || "Unknown"}
                                </h3>
                                {match.provider && (
                                  <Badge variant="secondary" className="font-medium">
                                    {match.provider.category}
                                  </Badge>
                                )}
                                <Badge className="bg-primary text-primary-foreground px-2 py-0.5 text-xs font-medium">
                                  Completed
                                </Badge>
                              </div>
                              <p className="text-sm text-muted-foreground mb-3">{match.reason}</p>
                              {match.provider && (
                                <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground mb-4">
                                  {match.provider.location && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">📍</span>{" "}
                                      {match.provider.location}
                                    </span>
                                  )}
                                  <span className="flex items-center gap-1">
                                    <span className="font-medium">⭐</span>{" "}
                                    {(match.provider.avg_rating ?? 0).toFixed(1)} (
                                    {match.provider.rating_count ?? 0})
                                  </span>
                                  {match.provider.hourly_rate && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">💰</span> R
                                      {match.provider.hourly_rate}/hr
                                    </span>
                                  )}
                                </div>
                              )}
                            </div>
                            <div className="flex flex-col gap-2">
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => navigate({ to: `/chat/${match.id}` })}
                                className="bg-gradient-hero text-white border-0"
                              >
                                <MessageSquare className="w-4 h-4 mr-1" />
                                View Chat
                              </Button>
                              {match.has_rated ? (
                                <Badge className="bg-success text-success-foreground w-fit">
                                  <Star className="w-3 h-3 mr-1" />
                                  Rated
                                </Badge>
                              ) : (
                                <Button
                                  size="sm"
                                  onClick={() => handleRateProvider(match)}
                                  className="bg-primary text-white"
                                >
                                  <Star className="w-4 h-4 mr-1" />
                                  Rate Provider
                                </Button>
                              )}
                              {match.is_favorited ? (
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() => {
                                    if (match.provider) {
                                      removeFavoriteMutation.mutate(match.provider.id);
                                    }
                                  }}
                                  disabled={removeFavoriteMutation.isPending}
                                  className="text-xs"
                                >
                                  <Heart className="w-4 h-4 mr-1 fill-red-500 text-red-500" />
                                  Remove from Favorites
                                </Button>
                              ) : (
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={() => {
                                    if (match.provider) {
                                      addFavoriteMutation.mutate(match.provider.id);
                                    }
                                  }}
                                  disabled={addFavoriteMutation.isPending}
                                  className="text-xs"
                                >
                                  <Heart className="w-4 h-4 mr-1" />
                                  Add to Favorites
                                </Button>
                              )}
                              <Button
                                size="sm"
                                variant="destructive"
                                onClick={() => {
                                  setReportingMatch(match);
                                  setReportDialogOpen(true);
                                }}
                                className="text-xs"
                              >
                                Report Provider
                              </Button>
                            </div>
                          </div>
                        </Card>
                      ))}
                  </div>
                </section>
              )}

              {/* Declined Matches Section */}
              {clientMatches.filter((m) => m.inquiry_status === "declined").length > 0 && (
                <section id="declined-requests" className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive text-destructive-foreground">
                      <XCircle className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">Declined Requests</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mb-4">
                    Requests that providers have declined.
                  </p>
                  <div className="space-y-3">
                    {clientMatches
                      .filter((m) => m.inquiry_status === "declined")
                      .map((match) => (
                        <Card
                          key={match.id}
                          className="p-5 shadow-card border-2 border-destructive/20"
                        >
                          <div className="flex items-start justify-between gap-4">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-2">
                                <h3 className="font-semibold text-lg">
                                  {match.provider?.business_name || "Unknown"}
                                </h3>
                                {match.provider && (
                                  <Badge variant="secondary" className="font-medium">
                                    {match.provider.category}
                                  </Badge>
                                )}
                                <Badge className="bg-destructive text-destructive-foreground px-2 py-0.5 text-xs font-medium">
                                  Declined
                                </Badge>
                              </div>
                              <p className="text-sm text-muted-foreground mb-3">{match.reason}</p>
                              {match.provider && (
                                <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                                  {match.provider.location && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">📍</span>{" "}
                                      {match.provider.location}
                                    </span>
                                  )}
                                  <span className="flex items-center gap-1">
                                    <span className="font-medium">⭐</span>{" "}
                                    {(match.provider.avg_rating ?? 0).toFixed(1)} (
                                    {match.provider.rating_count ?? 0})
                                  </span>
                                  {match.provider.hourly_rate && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">💰</span> R
                                      {match.provider.hourly_rate}/hr
                                    </span>
                                  )}
                                </div>
                              )}
                            </div>
                            <div className="flex flex-col gap-2">
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => {
                                  setText(match.service_request?.request_text || "");
                                  setResult(null);
                                  setRequestedIds(new Set());
                                  searchFormRef.current?.scrollIntoView({ behavior: "smooth" });
                                  setTimeout(() => submitMutation.mutate(), 500);
                                }}
                                disabled={submitMutation.isPending}
                                className="bg-gradient-hero text-white border-0"
                              >
                                <Sparkles className="w-4 h-4 mr-1" />
                                Find Other Providers
                              </Button>
                            </div>
                          </div>
                        </Card>
                      ))}
                  </div>
                </section>
              )}

              {/* Report Provider Dialog */}
              <Dialog open={reportDialogOpen} onOpenChange={setReportDialogOpen}>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Report Provider</DialogTitle>
                    <DialogDescription>
                      Report {reportingMatch?.provider?.business_name || "this provider"} to admin.
                      Please provide details about why they became quiet after accepting the job.
                    </DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <Label htmlFor="report-text">Report details</Label>
                      <Textarea
                        id="report-text"
                        placeholder="Describe the issue... (e.g., Provider accepted the job but stopped responding, hasn't shown up, etc.)"
                        value={reportText}
                        onChange={(e) => setReportText(e.target.value)}
                        rows={4}
                        maxLength={1000}
                      />
                      <p className="text-xs text-muted-foreground">
                        {reportText.length}/1000 characters
                      </p>
                    </div>
                  </div>
                  <DialogFooter>
                    <Button
                      variant="outline"
                      onClick={() => {
                        setReportDialogOpen(false);
                        setReportText("");
                        setReportingMatch(null);
                      }}
                    >
                      Cancel
                    </Button>
                    <Button
                      variant="destructive"
                      onClick={() => reportMutation.mutate()}
                      disabled={reportMutation.isPending || reportText.trim().length < 10}
                    >
                      {reportMutation.isPending ? "Submitting..." : "Submit Report"}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {/* Cancel Request Confirmation Dialog */}
              <Dialog open={cancelDialogOpen} onOpenChange={setCancelDialogOpen}>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Cancel Request</DialogTitle>
                    <DialogDescription>
                      Are you sure you want to cancel this request? This action cannot be undone.
                    </DialogDescription>
                  </DialogHeader>
                  {cancellingRequest && (
                    <div className="mt-2 p-2 bg-muted rounded text-sm">
                      "{cancellingRequest.request_text.substring(0, 100)}
                      {cancellingRequest.request_text.length > 100 ? "..." : ""}"
                    </div>
                  )}
                  <DialogFooter>
                    <Button
                      variant="outline"
                      onClick={() => setCancelDialogOpen(false)}
                      disabled={cancelRequestMutation.isPending}
                    >
                      Keep Request
                    </Button>
                    <Button
                      variant="destructive"
                      onClick={confirmCancelRequest}
                      disabled={cancelRequestMutation.isPending}
                    >
                      {cancelRequestMutation.isPending ? "Cancelling..." : "Cancel Request"}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {/* Cancel Job Confirmation Dialog */}
              <Dialog open={cancelMatchDialogOpen} onOpenChange={setCancelMatchDialogOpen}>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Cancel Job</DialogTitle>
                    <DialogDescription>
                      Are you sure you want to cancel this job? This will end the current work with{" "}
                      {cancellingMatch?.provider?.business_name || "this provider"}. This action
                      cannot be undone.
                    </DialogDescription>
                  </DialogHeader>
                  <DialogFooter>
                    <Button
                      variant="outline"
                      onClick={() => setCancelMatchDialogOpen(false)}
                      disabled={cancelMatchMutation.isPending}
                    >
                      Keep Job
                    </Button>
                    <Button
                      variant="destructive"
                      onClick={confirmCancelMatch}
                      disabled={cancelMatchMutation.isPending}
                    >
                      {cancelMatchMutation.isPending ? "Cancelling..." : "Cancel Job"}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {/* Rating Dialog */}
              <Dialog open={ratingDialogOpen} onOpenChange={setRatingDialogOpen}>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>
                      Rate {ratingMatch?.provider?.business_name || "Provider"}
                    </DialogTitle>
                    <DialogDescription>
                      How was your experience with this provider? Your rating helps others make
                      informed decisions.
                    </DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <Label className="text-base font-semibold">Your Rating</Label>
                      <div className="flex justify-center">
                        <StarRating value={rating} onChange={setRating} />
                      </div>
                      <p className="text-center text-sm text-muted-foreground">
                        {rating === 0
                          ? "Select a rating"
                          : rating === 1
                            ? "Poor"
                            : rating === 2
                              ? "Fair"
                              : rating === 3
                                ? "Good"
                                : rating === 4
                                  ? "Very Good"
                                  : "Excellent"}
                      </p>
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="rating-comment">Comment (optional)</Label>
                      <Textarea
                        id="rating-comment"
                        placeholder="Share your experience with this provider..."
                        value={ratingComment}
                        onChange={(e) => setRatingComment(e.target.value)}
                        rows={3}
                        maxLength={500}
                      />
                      <p className="text-xs text-muted-foreground">
                        {ratingComment.length}/500 characters
                      </p>
                    </div>
                  </div>
                  <DialogFooter>
                    <Button
                      variant="outline"
                      onClick={() => {
                        setRatingDialogOpen(false);
                        setRating(0);
                        setRatingComment("");
                        setRatingMatch(null);
                      }}
                    >
                      Cancel
                    </Button>
                    <Button
                      onClick={() => ratingMutation.mutate()}
                      disabled={ratingMutation.isPending || rating === 0}
                      className="bg-gradient-hero text-white"
                    >
                      {ratingMutation.isPending ? "Submitting..." : "Submit Rating"}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {showRequestHistory && (recentRequests.length > 0 || pastLoading) && (
                <section id="recent-requests" className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-secondary text-secondary-foreground">
                      <History className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">Recent Requests</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mb-4">
                    Your past service requests that are not currently active.
                  </p>
                  {pastLoading ? (
                    <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                      <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                      Loading…
                    </div>
                  ) : paginatedRecentRequests.length === 0 ? (
                    <Card className="p-8 text-center text-sm text-muted-foreground shadow-card">
                      <div className="flex flex-col items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                          <History className="w-6 h-6 text-muted-foreground" />
                        </div>
                        <p>No recent requests.</p>
                      </div>
                    </Card>
                  ) : (
                    <>
                      <div className="space-y-2">
                        {paginatedRecentRequests.map((r) => (
                          <Card
                            key={r.id}
                            className="p-4 text-sm shadow-card border-2 border-transparent hover:border-secondary/20 transition-smooth"
                          >
                            <div className="flex items-start justify-between gap-3">
                              <div className="flex-1">
                                <p className="line-clamp-2 mb-2">{r.request_text}</p>
                                {r.service_type && (
                                  <Badge variant="outline" className="text-xs">
                                    {r.service_type}
                                  </Badge>
                                )}
                              </div>
                              <div className="flex items-center gap-2">
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="text-xs h-7 border-2"
                                  onClick={() => {
                                    setText(r.request_text);
                                    setResult(null);
                                    setRequestedIds(new Set());
                                    submitMutation.mutate();
                                  }}
                                  disabled={submitMutation.isPending}
                                >
                                  {submitMutation.isPending ? "Searching..." : "Search again"}
                                </Button>
                              </div>
                            </div>
                          </Card>
                        ))}
                      </div>
                    </>
                  )}
                </section>
              )}

              {/* Favorite Providers Section */}
              {(favoriteProviders.length > 0 || favoritesLoading) && (
                <section id="favorite-providers" className="mt-8 fade-in">
                  <div className="flex items-center gap-2 mb-4">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-hero text-white">
                      <Heart className="w-4 h-4" />
                    </div>
                    <h2 className="text-xl font-semibold">Favorite Providers</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mb-4">
                    Providers you've saved for future reference.
                  </p>
                  {favoritesLoading ? (
                    <div className="flex items-center gap-2 text-sm text-muted-foreground p-4">
                      <div className="animate-spin h-4 w-4 border-2 border-primary border-t-transparent rounded-full" />
                      Loading…
                    </div>
                  ) : favoriteProviders.length === 0 ? (
                    <Card className="p-8 text-center text-sm text-muted-foreground shadow-card">
                      <div className="flex flex-col items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                          <Heart className="w-6 h-6 text-muted-foreground" />
                        </div>
                        <p className="font-medium">No favorite providers yet</p>
                        <p className="text-xs">
                          Add providers you enjoy working with to see them here. Click the heart
                          icon on any provider card to save them.
                        </p>
                        <Button asChild variant="outline" size="sm">
                          <Link to="/providers">Browse providers</Link>
                        </Button>
                      </div>
                    </Card>
                  ) : (
                    <div className="space-y-3">
                      {favoriteProviders.map((favorite) => (
                        <Card
                          key={favorite.provider_id}
                          className="p-5 shadow-card border-2 border-transparent hover:border-primary/20 transition-smooth"
                        >
                          <div className="flex items-start justify-between gap-4">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-2">
                                <h3 className="font-semibold text-lg">
                                  {favorite.service_providers?.business_name || "Unknown"}
                                </h3>
                                {favorite.service_providers && (
                                  <Badge variant="secondary" className="font-medium">
                                    {favorite.service_providers.category}
                                  </Badge>
                                )}
                              </div>
                              {favorite.service_providers && (
                                <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground mb-4">
                                  {favorite.service_providers.location && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">📍</span>{" "}
                                      {favorite.service_providers.location}
                                    </span>
                                  )}
                                  <span className="flex items-center gap-1">
                                    <span className="font-medium">⭐</span>{" "}
                                    {(favorite.service_providers.avg_rating ?? 0).toFixed(1)} (
                                    {favorite.service_providers.rating_count ?? 0})
                                  </span>
                                  {favorite.service_providers.hourly_rate && (
                                    <span className="flex items-center gap-1">
                                      <span className="font-medium">💰</span> R
                                      {favorite.service_providers.hourly_rate}/hr
                                    </span>
                                  )}
                                  {favorite.service_providers.verification_status ===
                                    "verified" && (
                                    <Badge className="bg-success text-success-foreground">
                                      Verified
                                    </Badge>
                                  )}
                                </div>
                              )}
                              <p className="text-xs text-muted-foreground">
                                Added {new Date(favorite.created_at).toLocaleDateString()}
                              </p>
                            </div>
                            <div className="flex flex-col gap-2">
                              <Button
                                size="sm"
                                onClick={() => {
                                  setFavoriteRequestTarget({
                                    id: favorite.provider_id,
                                    name: favorite.service_providers?.business_name || "Unknown",
                                  });
                                  setFavoriteRequestDialogOpen(true);
                                }}
                                className="bg-gradient-hero text-white"
                              >
                                Request
                              </Button>
                              <Button
                                size="sm"
                                variant="outline"
                                onClick={() => {
                                  removeFavoriteMutation.mutate(favorite.provider_id);
                                }}
                                disabled={removeFavoriteMutation.isPending}
                                className="text-xs"
                              >
                                <Heart className="w-4 h-4 mr-1 fill-red-500 text-red-500" />
                                Remove
                              </Button>
                            </div>
                          </div>
                        </Card>
                      ))}
                    </div>
                  )}
                </section>
              )}

              {/* Mobile Stats Section */}
              <div className="lg:hidden mt-8">
                <Button
                  variant="outline"
                  className="w-full justify-between"
                  onClick={() => setShowMobileStats(!showMobileStats)}
                >
                  <span>Quick Stats</span>
                  <ChevronDown
                    className={`w-4 h-4 transition-transform ${showMobileStats ? "rotate-180" : ""}`}
                  />
                </Button>
                {showMobileStats && (
                  <div className="mt-4 space-y-4">
                    <div className="grid grid-cols-2 gap-3">
                      <Card className="p-4 text-center shadow-card border-2 border-success/20">
                        <div className="text-2xl font-bold text-success">
                          {clientMatches.filter((m) => m.inquiry_status === "accepted").length}
                        </div>
                        <div className="text-xs text-muted-foreground mt-1">Active Jobs</div>
                      </Card>
                      <Card className="p-4 text-center shadow-card border-2 border-primary/20">
                        <div className="text-2xl font-bold text-primary">
                          {allPastRequests.length}
                        </div>
                        <div className="text-xs text-muted-foreground mt-1">Total Requests</div>
                      </Card>
                      <Card className="p-4 text-center shadow-card border-2 border-accent/20">
                        <div className="text-2xl font-bold text-accent">
                          {favoriteProviders.length}
                        </div>
                        <div className="text-xs text-muted-foreground mt-1">Favorites</div>
                      </Card>
                      <Card className="p-4 text-center shadow-card border-2 border-warning/20">
                        <div className="text-2xl font-bold text-warning">
                          {clientMatches.filter((m) => m.inquiry_status === "completed").length}
                        </div>
                        <div className="text-xs text-muted-foreground mt-1">Completed</div>
                      </Card>
                      <Card className="p-4 text-center shadow-card border-2 border-destructive/20">
                        <div className="text-2xl font-bold text-destructive">
                          {clientMatches.filter((m) => m.inquiry_status === "declined").length}
                        </div>
                        <div className="text-xs text-muted-foreground mt-1">Declined</div>
                      </Card>
                    </div>
                    <Card className="p-4 shadow-card border-2 border-accent/20 bg-accent/5">
                      <div className="flex items-start gap-3">
                        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-accent text-accent-foreground flex-shrink-0">
                          <Sparkles className="w-4 h-4" />
                        </div>
                        <div>
                          <p className="text-sm font-medium mb-1">Be Specific</p>
                          <p className="text-xs text-muted-foreground">
                            The more details you provide about your service needs, the better our AI
                            can match you with the right providers.
                          </p>
                        </div>
                      </div>
                    </Card>
                  </div>
                )}
              </div>
            </div>
          </main>

          {/* Right Sidebar */}
          <aside className="hidden lg:block w-80 border-l border-border/60 bg-sidebar/50 backdrop-blur-sm">
            <div className="p-6 space-y-6">
              {/* Quick Stats */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Quick Stats
                </h3>
                <div className="grid grid-cols-2 gap-3">
                  <Card className="p-4 text-center shadow-card border-2 border-success/20">
                    <div className="text-2xl font-bold text-success">
                      {clientMatches.filter((m) => m.inquiry_status === "accepted").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">Active Jobs</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-primary/20">
                    <div className="text-2xl font-bold text-primary">{allPastRequests.length}</div>
                    <div className="text-xs text-muted-foreground mt-1">Total Requests</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-accent/20">
                    <div className="text-2xl font-bold text-accent">{favoriteProviders.length}</div>
                    <div className="text-xs text-muted-foreground mt-1">Favorites</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-warning/20">
                    <div className="text-2xl font-bold text-warning">
                      {clientMatches.filter((m) => m.inquiry_status === "completed").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">Completed</div>
                  </Card>
                  <Card className="p-4 text-center shadow-card border-2 border-destructive/20">
                    <div className="text-2xl font-bold text-destructive">
                      {clientMatches.filter((m) => m.inquiry_status === "declined").length}
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">Declined</div>
                  </Card>
                </div>
              </div>

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
                      <p className="text-sm font-medium mb-1">Be Specific</p>
                      <p className="text-xs text-muted-foreground">
                        The more details you provide about your service needs, the better our AI can
                        match you with the right providers.
                      </p>
                    </div>
                  </div>
                </Card>
                <Card className="p-4 shadow-card border-2 border-warning/20 bg-warning/5">
                  <div className="flex items-start gap-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-warning text-warning-foreground flex-shrink-0">
                      <TrendingUp className="w-4 h-4" />
                    </div>
                    <div>
                      <p className="text-sm font-medium mb-1">Check Reviews</p>
                      <p className="text-xs text-muted-foreground">
                        Always review provider ratings and feedback before making your final
                        decision.
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
                {allPastRequests.length > 0 ? (
                  <div className="space-y-2">
                    {allPastRequests.slice(0, 3).map((request) => (
                      <Card key={request.id} className="p-3 shadow-card border border-border/60">
                        <div className="flex items-start gap-2">
                          <div
                            className={`flex h-6 w-6 items-center justify-center rounded-full flex-shrink-0 ${
                              request.status === "matched"
                                ? "bg-success/20 text-success"
                                : request.status === "cancelled"
                                  ? "bg-destructive/20 text-destructive"
                                  : "bg-muted text-muted-foreground"
                            }`}
                          >
                            {request.status === "matched"
                              ? "✓"
                              : request.status === "cancelled"
                                ? "✕"
                                : "○"}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-medium truncate">{request.request_text}</p>
                            <p className="text-xs text-muted-foreground mt-1">
                              {new Date(request.created_at).toLocaleDateString()}
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

              {/* Favorite Providers */}
              <div className="space-y-4">
                <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                  Favorite Providers
                </h3>
                {favoriteProviders.length > 0 ? (
                  <div className="space-y-2">
                    {favoriteProviders.slice(0, 3).map((favorite) => (
                      <Card
                        key={favorite.provider_id}
                        className="p-3 shadow-card border border-border/60"
                      >
                        <div className="flex items-start gap-2">
                          <div className="flex h-6 w-6 items-center justify-center rounded-full bg-accent/20 text-accent flex-shrink-0">
                            <Heart className="w-3 h-3 fill-red-500 text-red-500" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-medium truncate">
                              {favorite.service_providers?.business_name || "Unknown"}
                            </p>
                            <p className="text-xs text-muted-foreground mt-1">
                              {favorite.service_providers?.category}
                            </p>
                          </div>
                        </div>
                      </Card>
                    ))}
                    {favoriteProviders.length > 3 && (
                      <Button
                        size="sm"
                        variant="ghost"
                        className="w-full text-xs"
                        onClick={() => {
                          const favoritesSection = document.getElementById("favorite-providers");
                          favoritesSection?.scrollIntoView({ behavior: "smooth" });
                        }}
                      >
                        View All ({favoriteProviders.length})
                      </Button>
                    )}
                  </div>
                ) : (
                  <Card className="p-4 text-center text-sm text-muted-foreground shadow-card">
                    <p>No favorites yet.</p>
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
                        onClick={() => navigate({ to: "/contact-support" })}
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
