import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
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
import { requestProvider } from "@/server/inquiry.functions";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

interface ProviderInquiryDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  matchId: string;
  providerName: string;
  onSuccess: () => void;
}

export function ProviderInquiryDialog({
  open,
  onOpenChange,
  matchId,
  providerName,
  onSuccess,
}: ProviderInquiryDialogProps) {
  const [message, setMessage] = useState("");
  const [preferredDate, setPreferredDate] = useState("");

  const submitMutation = useMutation({
    mutationFn: async () => {
      const { data: { session } } = await supabase.auth.getSession();
      return requestProvider({
        data: {
          match_id: matchId,
          message: message.trim(),
          preferred_date: preferredDate || null,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
    },
    onSuccess: () => {
      toast.success(`Request sent to ${providerName}!`);
      setMessage("");
      setPreferredDate("");
      onOpenChange(false);
      onSuccess();
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send request");
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (message.trim().length < 10) {
      toast.error("Please add a bit more detail (at least 10 characters).");
      return;
    }
    submitMutation.mutate();
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Request {providerName}</DialogTitle>
            <DialogDescription>
              Send a message with any details the provider should know. They'll be notified of your request.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-1.5">
              <Label htmlFor="inquiry-message">Your message</Label>
              <Textarea
                id="inquiry-message"
                rows={4}
                placeholder="e.g. The tap has been leaking for 2 days. I'm available Saturday morning."
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                maxLength={1000}
              />
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
            <Button type="submit" className="bg-black text-white" disabled={submitMutation.isPending}>
              {submitMutation.isPending ? "Sending…" : "Send request"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
