import { createFileRoute, Link } from "@tanstack/react-router";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { MessageSquare, Mail, Clock, Shield } from "lucide-react";

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
            <Button asChild size="lg" className="bg-gradient-hero text-white shadow-md">
              <Link to="/settings">Submit Support Request</Link>
            </Button>
          </div>
        </section>
      </main>
    </div>
  );
}

const supportOptions = [
  {
    title: "Submit a Request",
    desc: "Send a support message directly from your settings page. Our team will review and respond as soon as possible.",
    icon: <MessageSquare className="w-5 h-5" />,
  },
  {
    title: "Quick Response",
    desc: "Our support team typically responds within 24-48 hours for general inquiries and faster for urgent issues.",
    icon: <Clock className="w-5 h-5" />,
  },
  {
    title: "Track Your Requests",
    desc: "View all your support messages and admin responses in one place on your settings page.",
    icon: <Mail className="w-5 h-5" />,
  },
  {
    title: "Secure & Private",
    desc: "All support communications are encrypted and only visible to you and our support team.",
    icon: <Shield className="w-5 h-5" />,
  },
];
