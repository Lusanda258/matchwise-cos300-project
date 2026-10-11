import { createFileRoute, Link } from "@tanstack/react-router";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { ScrollToTop } from "@/components/ScrollToTop";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles, Users, Clock, CheckCircle2, Star, Zap, TrendingUp } from "lucide-react";

export const Route = createFileRoute("/")({
  component: Landing,
  head: () => ({
    meta: [
      { title: "MatchWise — AI matches you with trusted service providers" },
      { name: "description", content: "Describe what you need in plain words. Our AI instantly recommends verified providers ranked by relevance, location, and ratings." },
    ],
  }),
});

function Landing() {
  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />
      <main className="flex-1">
        {/* Hero */}
        <section className="relative overflow-hidden bg-gradient-soft">
          <div className="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-accent/5"></div>
          <div className="absolute top-20 left-10 w-72 h-72 bg-primary/10 rounded-full blur-3xl animate-pulse"></div>
          <div className="absolute bottom-20 right-10 w-96 h-96 bg-accent/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: "1s" }}></div>
          
          <div className="relative mx-auto max-w-6xl px-4 py-20 md:py-28">
            <div className="mx-auto max-w-3xl text-center">
              <Badge className="mb-6 bg-primary/10 text-primary border-primary/20 hover:bg-primary/20">
                <Sparkles className="w-3 h-3 mr-1" />
                Powered by AI
              </Badge>
              
              <h1 className="text-balance text-5xl font-bold tracking-tight md:text-6xl">
                Find the right provider,{" "}
                <span className="text-gradient">in your words.</span>
              </h1>
              <p className="mt-6 text-pretty text-lg text-muted-foreground md:text-xl">
                Describe what you need, a tutor for matric maths, a stylist for a wedding —
                and our AI matches you with verified providers ranked by relevance, location, and ratings.
              </p>
              <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
                <Button asChild size="lg" className="bg-gradient-hero text-white shadow-lg hover:shadow-xl transition-all">
                  <Link to="/auth">
                    <Zap className="w-4 h-4 mr-2" />
                    Find a service
                  </Link>
                </Button>
                <Button asChild size="lg" variant="outline" className="border-2 hover:bg-accent/10 transition-all">
                  <Link to="/auth">Become a provider</Link>
                </Button>
              </div>
              
              <div className="mt-12 flex flex-wrap items-center justify-center gap-8 text-sm text-muted-foreground">
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4 text-primary" />
                  <span>100% Verified</span>
                </div>
                <div className="flex items-center gap-2">
                  <Users className="w-4 h-4 text-primary" />
                  <span>Trusted Platform</span>
                </div>
                <div className="flex items-center gap-2">
                  <Clock className="w-4 h-4 text-primary" />
                  <span>Instant Matching</span>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Stats */}
        <section className="border-y border-border/60 bg-white">
          <div className="mx-auto max-w-6xl px-4 py-12">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
              {stats.map((stat, i) => (
                <div key={stat.label} className="text-center">
                  <div className="text-3xl font-bold text-gradient">{stat.value}</div>
                  <div className="mt-1 text-sm text-muted-foreground">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
        </section>
      
        {/* How it works */}
        <section className="border-y border-border/60 bg-muted/30">
          <div className="mx-auto max-w-6xl px-4 py-20">
            <div className="mb-12 text-center">
              <Badge className="mb-4 bg-primary/10 text-primary border-primary/20">Simple Process</Badge>
              <h2 className="text-3xl font-bold tracking-tight md:text-4xl">Three steps. That's it.</h2>
              <p className="mt-3 text-muted-foreground">Get matched with the perfect service provider in minutes</p>
            </div>
            <div className="grid gap-6 md:grid-cols-3">
              {steps.map((s, i) => {
                const Icon = iconMap[s.icon];
                return (
                  <div key={s.title} className="relative rounded-2xl bg-card p-6 shadow-card hover:shadow-lg transition-all border border-border/50 hover-lift cursor-pointer">
                    <div className="absolute -top-4 left-6 flex h-8 w-8 items-center justify-center rounded-full bg-gradient-hero text-sm font-bold text-white shadow-lg">
                      {i + 1}
                    </div>
                    <div className="mt-2 mb-3 text-primary">
                      <Icon className="w-6 h-6" />
                    </div>
                    <h3 className="mt-2 text-lg font-semibold">{s.title}</h3>
                    <p className="mt-2 text-sm text-muted-foreground">{s.desc}</p>
                  </div>
                );
              })}
            </div>
          </div>
        </section>

        {/* Features */}
        <section className="bg-white">
          <div className="mx-auto max-w-6xl px-4 py-20">
            <div className="mb-12 text-center">
              <Badge className="mb-4 bg-accent/10 text-accent border-accent/20">Why Choose Us</Badge>
              <h2 className="text-3xl font-bold tracking-tight md:text-4xl">Smarter service matching</h2>
              <p className="mt-3 text-muted-foreground">AI-powered features that save you time and ensure quality</p>
            </div>
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
              {features.map((feature, i) => {
                const Icon = iconMap[feature.icon];
                return (
                  <div key={feature.title} className="rounded-2xl bg-card p-6 shadow-card hover:shadow-lg transition-all border border-border/50 hover-lift cursor-pointer">
                    <div className="mb-4 text-primary"><Icon className="w-5 h-5" /></div>
                    <h3 className="text-lg font-semibold">{feature.title}</h3>
                    <p className="mt-2 text-sm text-muted-foreground">{feature.desc}</p>
                  </div>
                );
              })}
            </div>
          </div>
        </section>

        {/* CTA */}
        <section className="relative overflow-hidden bg-gradient-hero">
          <div className="absolute inset-0 bg-black/10"></div>
          <div className="relative mx-auto max-w-4xl px-4 py-20 text-center">
            <Badge className="mb-4 bg-white/20 text-white border-white/30 backdrop-blur-sm">
              <TrendingUp className="w-3 h-3 mr-1" />
              Join thousands
            </Badge>
            <h2 className="text-3xl font-bold tracking-tight md:text-4xl text-white">Ready to find your match?</h2>
            <p className="mt-3 text-white/80">Join MatchWise today — clients and providers welcome.</p>
            <Button asChild size="lg" className="mt-8 bg-white text-primary hover:bg-white/90 shadow-xl transition-all">
              <Link to="/auth">Get started free</Link>
            </Button>
          </div>
        </section>
      </main>
      <Footer />
      <ScrollToTop />
    </div>
  );
}


const stats = [
  { value: "10K+", label: "Verified Providers" },
  { value: "50K+", label: "Happy Clients" },
  { value: "4.8★", label: "Average Rating" },
  { value: "24/7", label: "Support Available" },
];

const steps = [
  { 
    title: "Describe what you need", 
    desc: "Type it like you'd tell a friend — our AI handles the rest.",
    icon: "Sparkles"
  },
  { 
    title: "Get smart matches", 
    desc: "We rank verified providers by relevance, distance, and rating.",
    icon: "Users"
  },
  { 
    title: "Connect & rate", 
    desc: "Reach out, get the job done, and leave feedback for the community.",
    icon: "Star"
  },
];

const features = [
  {
    title: "AI-Powered Matching",
    desc: "Our intelligent algorithm understands your needs and finds the perfect match in seconds.",
    icon: "Sparkles"
  },
  {
    title: "Verified Providers",
    desc: "Every provider is thoroughly vetted to ensure quality, reliability, and trustworthiness.",
    icon: "CheckCircle2"
  },
  {
    title: "Real-Time Availability",
    desc: "See provider availability instantly and book services that fit your schedule perfectly.",
    icon: "Clock"
  },
  {
    title: "Transparent Pricing",
    desc: "Clear, upfront pricing with no hidden fees. Compare rates and choose what works for you.",
    icon: "TrendingUp"
  },
  {
    title: "Secure Payments",
    desc: "Safe and secure payment processing with built-in protection for both clients and providers.",
    icon: "Users"
  },
  {
    title: "Quality Reviews",
    desc: "Honest reviews and ratings from real clients to help you make informed decisions.",
    icon: "Star"
  },
];

const iconMap: Record<string, React.ElementType> = {
  Zap,
  Users,
  Star,
  Sparkles,
  Clock,
  TrendingUp,
  CheckCircle2,
};
