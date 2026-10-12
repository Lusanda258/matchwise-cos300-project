import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
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
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { MessageSquare, Mail, Clock, Shield } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { submitSupportMessage, getUserSupportMessages } from "@/server/support.functions";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useRealtimeSubscription } from "@/hooks/useRealtime";

export const Route = createFileRoute("/contact-support")({
  component: ContactSupport,
  head: () => ({
    meta: [
      { title: "Contact Support — MatchWise" },
      { name: "description", content: "Get help with MatchWise. Submit support requests and view admin responses." },
    ],
  }),
});

function ContactSupport() {
  const [supportDialogOpen, setSupportDialogOpen] = useState(false);
  const [supportSubject, setSupportSubject] = useState("");
  const [supportMessage, setSupportMessage] = useState("");
  const [supportPriority, setSupportPriority] = useState("medium");

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

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />
      <main className="flex-1">
        <section className="bg-white">
          <div className="mx-auto max-w-4xl px-4 py-16 text-center">
            <h1 className="text-4xl font-bold tracking-tight md:text-5xl">Contact Support</h1>
            <p className="mt-4 text-lg text-muted-foreground">
              We're here to help. Submit a support request and our team will get back to you.
            </p>
          </div>
        </section>

        <section className="mx-auto max-w-5xl px-4 py-16">
          <div className="grid gap-5 md:grid-cols-2">
            {supportOptions.map((option) => (
              <Card key={option.title} className="border-border/60 p-6 shadow-card">
                <div className="flex items-start gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary flex-shrink-0">
                    {option.icon}
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold">{option.title}</h3>
                    <p className="mt-2 text-sm text-muted-foreground">{option.desc}</p>
                  </div>
                </div>
              </Card>
            ))}
          </div>

          <div className="mt-10 text-center">
            <Button
              size="lg"
              className="bg-gradient-hero text-white shadow-md"
              onClick={() => setSupportDialogOpen(true)}
            >
              Submit Support Request
            </Button>
          </div>

          {/* Support Messages */}
          {supportMessages.length > 0 && (
            <div className="mt-16">
              <h2 className="text-2xl font-bold mb-6">Your Support Requests</h2>
              <div className="space-y-3">
                {supportMessages.map((msg) => (
                  <Card key={msg.id} className="p-4 border-2 shadow-card">
                    <div className="flex items-start justify-between gap-2 mb-2">
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
                    {msg.admin_response && (
                      <div className="mt-2 p-2 bg-muted rounded text-xs">
                        <p className="font-medium text-muted-foreground mb-1">Admin Response:</p>
                        <p className="text-foreground">{msg.admin_response}</p>
                      </div>
                    )}
                  </Card>
                ))}
              </div>
            </div>
          )}
        </section>
      </main>

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
    </div>
  );
}

const supportOptions = [
  {
    title: "Submit a Request",
    desc: "Send a support message directly. Our team will review and respond as soon as possible.",
    icon: <MessageSquare className="w-5 h-5" />,
  },
  {
    title: "Quick Response",
    desc: "Our support team typically responds within 24-48 hours for general inquiries and faster for urgent issues.",
    icon: <Clock className="w-5 h-5" />,
  },
  {
    title: "Track Your Requests",
    desc: "View all your support messages and admin responses in one place on this page.",
    icon: <Mail className="w-5 h-5" />,
  },
  {
    title: "Secure & Private",
    desc: "All support communications are encrypted and only visible to you and our support team.",
    icon: <Shield className="w-5 h-5" />,
  },
];
