import { createFileRoute } from "@tanstack/react-router";
import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Navbar } from "@/components/Navbar";
import { RoleGate } from "@/components/RoleGate";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { useRealtimeSubscription } from "@/hooks/useRealtime";

export const Route = createFileRoute("/chat/$matchId")({
  component: () => (
    <RoleGate allow={["client", "provider"]}>
      <ChatPage />
    </RoleGate>
  ),
  head: () => ({ meta: [{ title: "Chat — MatchWise" }] }),
});

interface Message {
  id: string;
  match_id: string;
  sender_id: string;
  message: string;
  read: boolean;
  created_at: string;
  sender?: {
    id: string;
    full_name: string;
  };
}

interface Match {
  id: string;
  request_id: string;
  provider_id: string;
  status: string | null;
  inquiry_status: string | null;
  service_request?: {
    id: string;
    request_text: string;
    client_id: string;
    client?: {
      id: string;
      full_name: string;
    };
  };
  provider?: {
    id: string;
    business_name: string;
    user_id: string;
  };
}

function ChatPage() {
  const { matchId } = Route.useParams();
  const queryClient = useQueryClient();
  const [messageText, setMessageText] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Get current user
  const { data: authUser } = useQuery({
    queryKey: ["currentUser"],
    queryFn: async () => {
      const { data: authData } = await supabase.auth.getUser();
      return authData?.user;
    },
  });

  // Fetch match details
  const { data: match, isLoading: matchLoading } = useQuery({
    queryKey: ["match", matchId],
    queryFn: async () => {
      const { data: authData } = await supabase.auth.getUser();
      const user = authData?.user;
      if (!user) return null;

      const { data: m, error: matchError } = await supabase
        .from("matches")
        .select(
          `
          *,
          service_request:service_requests!matches_request_id_fkey(
            id,
            request_text,
            client_id
          ),
          provider:service_providers(id, business_name, user_id)
        `,
        )
        .eq("id", matchId)
        .single();

      if (matchError) {
        console.error("Error fetching match:", matchError);
        throw new Error(`Failed to fetch match: ${matchError.message}`);
      }

      if (!m) {
        return null;
      }

      // If provider data is missing, fetch it separately
      let matchWithProvider = m;
      if (!m.provider && m.provider_id) {
        const { data: providerData } = await supabase
          .from("service_providers")
          .select("id, business_name, user_id")
          .eq("id", m.provider_id)
          .single();

        if (providerData) {
          matchWithProvider = { ...m, provider: providerData };
        }
      }

      // If service_request data is missing, fetch it separately
      if (!m.service_request && m.request_id) {
        const { data: serviceRequestData, error: serviceRequestError } = await supabase
          .from("service_requests")
          .select("id, request_text, client_id")
          .eq("id", m.request_id)
          .single();

        if (serviceRequestError) {
          console.error("Error fetching service request:", serviceRequestError);
        }

        if (serviceRequestData) {
          matchWithProvider = { ...matchWithProvider, service_request: serviceRequestData };
        }
      }

      // Check if user is part of this match
      const isClient = matchWithProvider.service_request?.client_id === user.id;
      const isProvider = matchWithProvider.provider?.user_id === user.id;

      if (!isClient && !isProvider) {
        throw new Error("You don't have access to this chat");
      }

      // Check if match is accepted (either status field)
      const isAccepted =
        matchWithProvider.status === "accepted" || matchWithProvider.inquiry_status === "accepted";
      if (!isAccepted) {
        console.error("Access denied: Match not accepted");
        throw new Error(
          `Chat is only available for accepted matches. Current status: ${matchWithProvider.status || matchWithProvider.inquiry_status || "unknown"}`,
        );
      }

      // Fetch client info separately
      let clientInfo = null;
      if (matchWithProvider.service_request?.client_id) {
        const { data: client } = await supabase
          .from("profiles")
          .select("id, full_name")
          .eq("id", matchWithProvider.service_request.client_id)
          .single();
        clientInfo = client;
      }

      return {
        ...matchWithProvider,
        isClient,
        isProvider,
        service_request: matchWithProvider.service_request
          ? {
              ...matchWithProvider.service_request,
              client: clientInfo,
            }
          : undefined,
      } as Match & { isClient: boolean; isProvider: boolean };
    },
  });

  // Fetch messages
  const { data: messages = [], isLoading: messagesLoading } = useQuery({
    queryKey: ["messages", matchId],
    queryFn: async () => {
      const { data: m } = await supabase
        .from("messages")
        .select(
          `
          *,
          sender:profiles!sender_id(id, full_name)
        `,
        )
        .eq("match_id", matchId)
        .order("created_at", { ascending: true });
      return (m ?? []) as Message[];
    },
    enabled: !!match,
  });

  // Real-time subscription for messages
  useRealtimeSubscription({
    table: "messages",
    filter: `match_id=eq.${matchId}`,
    onInsert: () => {
      queryClient.invalidateQueries({ queryKey: ["messages", matchId] });
    },
    onUpdate: () => {
      queryClient.invalidateQueries({ queryKey: ["messages", matchId] });
    },
    enabled: !!match,
  });

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  }, [messages]);

  // Real-time subscription for new messages
  useEffect(() => {
    if (!matchId || !authUser) return;

    const channel = supabase
      .channel(`messages:${matchId}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "messages",
          filter: `match_id=eq.${matchId}`,
        },
        (payload) => {
          const newMessage = payload.new as Message;

          // Only show notification if message is not from current user
          if (newMessage.sender_id !== authUser.id) {
            const senderName = match.isClient
              ? match.provider?.business_name || "Provider"
              : match.service_request?.client?.full_name || "Client";

            toast.info(`New message from ${senderName}`);

            // Invalidate to refresh messages
            queryClient.invalidateQueries({ queryKey: ["messages", matchId] });
          }
        },
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [matchId, authUser, match, queryClient]);

  // Send message mutation
  const sendMessageMutation = useMutation({
    mutationFn: async (text: string) => {
      const { data: authData } = await supabase.auth.getUser();
      const user = authData?.user;
      if (!user) throw new Error("Not authenticated");

      const { error } = await supabase.from("messages").insert({
        match_id: matchId,
        sender_id: user.id,
        message: text,
        read: false,
      });

      if (error) {
        console.error("Message send error:", error);
        throw new Error(`Failed to send message: ${error.message}`);
      }
      return text;
    },
    onSuccess: async () => {
      setMessageText("");
      queryClient.invalidateQueries({ queryKey: ["messages", matchId] });

      // Create notification for recipient using Supabase RPC function
      try {
        const {
          data: { user },
        } = await supabase.auth.getUser();
        if (!user) return;

        await supabase.rpc("create_match_notification", {
          p_match_id: matchId,
          p_type: "info",
          p_title: "New Message",
          p_message: "You have a new message.",
          p_metadata: { match_id: matchId },
          p_sender_id: user.id, // Pass the sender's user ID
        });
      } catch (error) {
        // Silent fail - notification is best effort
      }
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send message");
    },
  });

  const sendMessage = (e: React.FormEvent) => {
    e.preventDefault();
    if (!messageText.trim()) return;
    sendMessageMutation.mutate(messageText);
  };

  if (matchLoading) {
    return (
      <div className="flex min-h-screen flex-col">
        <Navbar />
        <main className="flex-1 bg-white">
          <div className="mx-auto max-w-4xl px-4 py-10">
            <div className="flex items-center gap-2 text-sm text-muted-foreground">Loading…</div>
          </div>
        </main>
      </div>
    );
  }

  if (!match) {
    return (
      <div className="flex min-h-screen flex-col">
        <Navbar />
        <main className="flex-1 bg-white">
          <div className="mx-auto max-w-4xl px-4 py-10">
            <Card className="p-6 text-center">
              <h2 className="text-lg font-semibold">Chat not found</h2>
              <p className="mt-2 text-sm text-muted-foreground">
                This chat may have been deleted or you don't have access to it.
              </p>
            </Card>
          </div>
        </main>
      </div>
    );
  }

  const otherPartyName = match.isClient
    ? match.provider?.business_name || "Unknown Provider"
    : match.service_request?.client?.full_name || "";

  return (
    <div className="flex min-h-screen flex-col bg-gray-50">
      <Navbar />
      <main className="flex-1">
        <div className="mx-auto max-w-4xl px-4 py-6 sm:py-10">
          <div className="mb-6">
            <h1 className="text-2xl font-bold tracking-tight">
              {otherPartyName ? `Chat with ${otherPartyName}` : "Messages"}
            </h1>
            <p className="mt-1 text-sm text-muted-foreground">
              {match.service_request?.request_text || "Service request"}
            </p>
            <Badge
              variant={
                match.status === "accepted" || match.inquiry_status === "accepted"
                  ? "default"
                  : "secondary"
              }
              className="mt-2"
            >
              {match.status || match.inquiry_status || "Unknown"}
            </Badge>
          </div>

          <Card className="shadow-card overflow-hidden">
            {/* Messages Area */}
            <div
              className="h-[60vh] sm:h-[500px] overflow-y-auto p-4 space-y-3 bg-white"
              id="messages-container"
            >
              {messagesLoading ? (
                <div className="flex items-center justify-center h-full text-sm text-muted-foreground">
                  Loading messages…
                </div>
              ) : messages.length === 0 ? (
                <div className="flex items-center justify-center h-full text-sm text-muted-foreground">
                  No messages yet. Start the conversation!
                </div>
              ) : (
                messages.map((msg) => {
                  const isOwnMessage = msg.sender_id === authUser?.id;
                  return (
                    <div
                      key={msg.id}
                      className={`flex ${isOwnMessage ? "justify-end" : "justify-start"}`}
                    >
                      <div
                        className={`max-w-[85%] sm:max-w-[70%] rounded-2xl px-4 py-3 shadow-sm ${
                          isOwnMessage
                            ? "bg-black text-white"
                            : "bg-white border border-gray-200 text-gray-900"
                        }`}
                      >
                        <p className="text-sm leading-relaxed break-words">{msg.message}</p>
                        <p
                          className={`text-xs mt-2 ${isOwnMessage ? "text-gray-300" : "text-gray-500"}`}
                        >
                          {new Date(msg.created_at).toLocaleTimeString([], {
                            hour: "2-digit",
                            minute: "2-digit",
                          })}
                        </p>
                      </div>
                    </div>
                  );
                })
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Message Input */}
            <div className="p-4">
              <form onSubmit={sendMessage} className="flex gap-2">
                <Input
                  value={messageText}
                  onChange={(e) => setMessageText(e.target.value)}
                  placeholder="Type your message..."
                  disabled={sendMessageMutation.isPending}
                  className="flex-1"
                />
                <Button
                  type="submit"
                  disabled={sendMessageMutation.isPending || !messageText.trim()}
                  className="bg-black text-white"
                >
                  {sendMessageMutation.isPending ? "Sending…" : "Send"}
                </Button>
              </form>
            </div>
          </Card>
        </div>
      </main>
    </div>
  );
}
