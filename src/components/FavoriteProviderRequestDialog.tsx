import { useState, useEffect } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createMatchForFavorite, requestProvider, getMatchHistoryWithProvider } from "@/server/inquiry.functions";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

interface FavoriteProviderRequestDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  providerId: string;
  providerName: string;
  onSuccess: () => void;
}

export function FavoriteProviderRequestDialog({
  open,
  onOpenChange,
  providerId,
  providerName,
  onSuccess,
}: FavoriteProviderRequestDialogProps) {
  const queryClient = useQueryClient();
  const [requestText, setRequestText] = useState("");
  const [location, setLocation] = useState("");
  const [message, setMessage] = useState("");
  const [preferredDate, setPreferredDate] = useState("");
  const [createdMatchId, setCreatedMatchId] = useState<string | null>(null);

  // Fetch match history when dialog opens
  const { data: matchHistory, isLoading: isLoadingHistory } = useQuery({
    queryKey: ["matchHistory", providerId],
    queryFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      return getMatchHistoryWithProvider({
        data: { provider_id: providerId },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
    },
    enabled: open && providerId !== "",
  });

  // Pre-fill form when history is loaded
  useEffect(() => {
    if (matchHistory) {
      if (matchHistory.locations.length > 0 && !location) {
        setLocation(matchHistory.locations[0]);
      }
      if (matchHistory.recentRequests.length > 0 && !requestText) {
        setRequestText(matchHistory.recentRequests[0]);
      }
    }
  }, [matchHistory, location, requestText]);

  // Reset form when dialog closes
  useEffect(() => {
    if (!open) {
      setRequestText("");
      setLocation("");
      setMessage("");
      setPreferredDate("");
      setCreatedMatchId(null);
    }
  }, [open]);

  // Step 1: Create match
  const createMatchMutation = useMutation({
    mutationFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      return createMatchForFavorite({
        data: {
          provider_id: providerId,
          request_text: requestText.trim(),
          location: location.trim() || null,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
    },
    onSuccess: (result) => {
      setCreatedMatchId(result.match_id);
      // Automatically proceed to step 2
      requestMutation.mutate();
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to create request");
    },
  });

  // Step 2: Send request using existing function
  const requestMutation = useMutation({
    mutationFn: async () => {
      if (!createdMatchId) throw new Error("No match ID available");
      const { data: { session } } = await supabase.auth.getSession();
      return requestProvider({
        data: {
          match_id: createdMatchId,
          message: message.trim(),
          preferred_date: preferredDate || null,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
    },
    onSuccess: () => {
      toast.success(`Request sent to ${providerName}!`);
      setRequestText("");
      setLocation("");
      setMessage("");
      setPreferredDate("");
      setCreatedMatchId(null);
      onOpenChange(false);
      onSuccess();
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send request");
      setCreatedMatchId(null);
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (requestText.trim().length < 10) {
      toast.error("Please describe what you need (at least 10 characters).");
      return;
    }
    if (message.trim().length < 10) {
      toast.error("Please add a bit more detail to your message (at least 10 characters).");
      return;
    }
    createMatchMutation.mutate();
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Request {providerName}</DialogTitle>
            <DialogDescription>
              Send a service request to your favorite provider. They'll be notified of your request.
              {matchHistory?.hasHistory && (
                <span className="block mt-1 text-xs text-muted-foreground">
                  Based on your previous requests with this provider
                </span>
              )}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-1.5">
              <Label htmlFor="request-text">What do you need help with?</Label>
              <Textarea
                id="request-text"
                rows={3}
                placeholder="e.g. I need help fixing a leaking kitchen tap"
                value={requestText}
                onChange={(e) => setRequestText(e.target.value)}
                maxLength={2000}
                disabled={isLoadingHistory}
              />
              <p className="text-xs text-muted-foreground text-right">{requestText.length}/2000</p>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="location">Location (optional)</Label>
              <Input
                id="location"
                placeholder="e.g. Polokwane"
                value={location}
                onChange={(e) => setLocation(e.target.value)}
                maxLength={120}
                disabled={isLoadingHistory}
              />
              {matchHistory?.locations.length > 1 && (
                <div className="flex gap-2 mt-1 flex-wrap">
                  {matchHistory.locations.slice(1).map((loc) => (
                    <Button
                      key={loc}
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => setLocation(loc)}
                      className="text-xs"
                    >
                      {loc}
                    </Button>
                  ))}
                </div>
              )}
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="inquiry-message">Additional message for provider</Label>
              <Textarea
                id="inquiry-message"
                rows={3}
                placeholder="e.g. The tap has been leaking for 2 days. I'm available Saturday morning."
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                maxLength={1000}
              />
              <p className="text-xs text-muted-foreground text-right">{message.length}/1000</p>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="inquiry-date">Preferred date (optional)</Label>
              <Input
                id="inquiry-date"
                type="date"
                value={preferredDate}
                onChange={(e) => setPreferredDate(e.target.value)}
                min={new Date().toISOString().split("T")[0]}
              />
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" className="bg-black text-white" disabled={createMatchMutation.isPending || requestMutation.isPending || isLoadingHistory}>
              {createMatchMutation.isPending ? "Creating..." : requestMutation.isPending ? "Sending..." : isLoadingHistory ? "Loading..." : "Send request"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
