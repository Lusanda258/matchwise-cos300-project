import { createFileRoute, Link } from "@tanstack/react-router";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";

export const Route = createFileRoute("/how-it-works")({
  component: HowItWorks,
  head: () => ({
    meta: [
      { title: "How it works — MatchWise" },
      { name: "description", content: "Learn how MatchWise uses NLP, verification, and ratings to connect clients with trusted service providers." },
    ],
  }),
});

function HowItWorks() {
  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />
      <main className="flex-1">
        <section className="bg-white">
          <div className="mx-auto max-w-4xl px-4 py-16 text-center">
            <h1 className="text-4xl font-bold tracking-tight md:text-5xl">How MatchWise works</h1>
            <p className="mt-4 text-lg text-muted-foreground">
              An end-to-end pipeline: natural language → AI ranking → verified providers.
            </p>
          </div>
        </section>

        <section className="mx-auto max-w-5xl px-4 py-16">
          <div className="grid gap-5 md:grid-cols-2">
            {pillars.map((p) => (
              <Card key={p.title} className="border-border/60 p-6 shadow-card">
                <h3 className="text-lg font-semibold">{p.title}</h3>
                <p className="mt-2 text-sm text-muted-foreground">{p.desc}</p>
              </Card>
            ))}
          </div>


          <div className="mt-10 text-center">
            <Button asChild size="lg" className="bg-black text-white shadow-sm">
              <Link to="/auth">Try it now</Link>
            </Button>
          </div>
        </section>
      </main>
    </div>
  );
}

const pillars = [
  { title: "Client Portal", desc: "Submit requests in plain English and review smart matches." },
  { title: "AI Matching Engine", desc: "NLP extracts intent and ranks providers by relevance and location." },
  { title: "Provider Portal", desc: "Providers register, build profiles, and upload verification documents." },
  { title: "Verification Engine", desc: "Admins review documents to ensure only trustworthy providers are listed." },
  { title: "Secure Database", desc: "Encrypted storage with strict row-level access controls." },
  { title: "Notification Service", desc: "Updates on matches, requests, and verification status." },
];

