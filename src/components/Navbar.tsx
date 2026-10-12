import { Link } from "@tanstack/react-router";
import { useAuth, signOut } from "@/lib/auth";
import { Button } from "@/components/ui/button";
import { NotificationCenter } from "@/components/NotificationCenter";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Sparkles, Menu, X, HelpCircle, MessageSquare } from "lucide-react";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { submitSupportMessage } from "@/server/support.functions";
import { toast } from "sonner";
import { useMutation } from "@tanstack/react-query";

export function Navbar() {
  const { user, role, loading } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [supportDialogOpen, setSupportDialogOpen] = useState(false);
  const [supportSubject, setSupportSubject] = useState("");
  const [supportMessage, setSupportMessage] = useState("");
  const [supportPriority, setSupportPriority] = useState("medium");

  const supportMutation = useMutation({
    mutationFn: async () => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await submitSupportMessage({
        data: {
          subject: supportSubject,
          message: supportMessage,
          priority: supportPriority,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Support message sent successfully");
      setSupportDialogOpen(false);
      setSupportSubject("");
      setSupportMessage("");
      setSupportPriority("medium");
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send support message");
    },
  });

  const dashboardLink =
    role === "admin" ? "/admin" : role === "provider" ? "/provider" : "/dashboard";

  return (
    <header className="sticky top-0 z-40 w-full border-b border-border/60 bg-background/95 backdrop-blur-xl">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4">
        <Link to="/" className="flex items-center gap-2 group">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-hero text-white shadow-lg transition-all group-hover:scale-105">
            <Sparkles className="w-4 h-4" />
          </div>
          <span className="text-lg font-bold tracking-tight text-gradient">MatchWise</span>
        </Link>

        {/* Desktop Navigation */}
        <nav className="hidden items-center gap-6 md:flex">
          <Button asChild variant="ghost" size="sm" className="font-medium">
            <Link to="/how-it-works">
              <HelpCircle className="w-4 h-4 mr-2" />
              How it works
            </Link>
          </Button>
          {user && (
            <Button
              variant="ghost"
              size="sm"
              className="font-medium"
              onClick={() => setSupportDialogOpen(true)}
            >
              <MessageSquare className="w-4 h-4 mr-2" />
              Support
            </Button>
          )}
        </nav>

        {/* Desktop Auth Buttons */}
        <div className="hidden items-center gap-2 md:flex">
          {!loading && user ? (
            <>
              <NotificationCenter />
              <Button asChild variant="ghost" size="sm" className="font-medium">
                <Link to={dashboardLink}>Dashboard</Link>
              </Button>
              <Button size="sm" variant="outline" onClick={signOut} className="font-medium">
                Sign out
              </Button>
            </>
          ) : (
            <>
              <Button asChild variant="ghost" size="sm" className="font-medium">
                <Link to="/auth">Sign in</Link>
              </Button>
              <Button
                asChild
                size="sm"
                className="bg-gradient-hero text-white shadow-md hover:shadow-lg transition-all font-medium"
              >
                <Link to="/auth">Get started</Link>
              </Button>
            </>
          )}
        </div>

        {/* Mobile Menu Button */}
        <Button
          variant="ghost"
          size="icon"
          className="md:hidden"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
        >
          {mobileMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
        </Button>
      </div>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="md:hidden border-t border-border/60 bg-background/95 backdrop-blur-xl">
          <nav className="flex flex-col p-4 gap-4">
            <Button asChild variant="ghost" size="sm" className="w-full font-medium justify-start">
              <Link to="/how-it-works" onClick={() => setMobileMenuOpen(false)}>
                <HelpCircle className="w-4 h-4 mr-2" />
                How it works
              </Link>
            </Button>
            {user && (
              <Button
                variant="ghost"
                size="sm"
                className="w-full font-medium justify-start"
                onClick={() => {
                  setSupportDialogOpen(true);
                  setMobileMenuOpen(false);
                }}
              >
                <MessageSquare className="w-4 h-4 mr-2" />
                Support
              </Button>
            )}
            <div className="h-px bg-border/60" />
            {!loading && user ? (
              <>
                <Button
                  asChild
                  variant="ghost"
                  size="sm"
                  className="w-full font-medium justify-start"
                >
                  <Link to={dashboardLink} onClick={() => setMobileMenuOpen(false)}>
                    Dashboard
                  </Link>
                </Button>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => {
                    signOut();
                    setMobileMenuOpen(false);
                  }}
                  className="w-full font-medium"
                >
                  Sign out
                </Button>
              </>
            ) : (
              <>
                <Button
                  asChild
                  variant="ghost"
                  size="sm"
                  className="w-full font-medium justify-start"
                >
                  <Link to="/auth" onClick={() => setMobileMenuOpen(false)}>
                    Sign in
                  </Link>
                </Button>
                <Button
                  asChild
                  size="sm"
                  className="w-full bg-gradient-hero text-white shadow-md hover:shadow-lg transition-all font-medium"
                >
                  <Link to="/auth" onClick={() => setMobileMenuOpen(false)}>
                    Get started
                  </Link>
                </Button>
              </>
            )}
          </nav>
        </div>
      )}

      {/* Support Dialog */}
      <Dialog open={supportDialogOpen} onOpenChange={setSupportDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Contact Support</DialogTitle>
            <DialogDescription>
              Send a message to our support team. We'll get back to you as soon as possible.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={(e) => {
            e.preventDefault();
            supportMutation.mutate();
          }} className="space-y-4 py-4">
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
              <Button
                type="button"
                variant="outline"
                onClick={() => {
                  setSupportDialogOpen(false);
                  setSupportSubject("");
                  setSupportMessage("");
                  setSupportPriority("medium");
                }}
              >
                Cancel
              </Button>
              <Button
                type="submit"
                disabled={supportMutation.isPending}
                className="bg-gradient-hero text-white"
              >
                {supportMutation.isPending ? "Sending..." : "Send Message"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </header>
  );
}
