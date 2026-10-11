import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { supabase } from "@/integrations/supabase/client";
import { Filter, X } from "lucide-react";

export const Route = createFileRoute("/providers")({
  component: ProvidersPage,
  head: () => ({
    meta: [
      { title: "Verified providers — MatchWise" },
      { name: "description", content: "Browse our directory of verified service providers." },
    ],
  }),
});

interface Provider {
  id: string;
  business_name: string;
  category: string;
  bio: string | null;
  location: string | null;
  hourly_rate: number | null;
  avg_rating: number | null;
  rating_count: number | null;
  status: string;
  verification_status: string;
}

function ProvidersPage() {
  const [providers, setProviders] = useState<Provider[]>([]);
  const [q, setQ] = useState("");
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [minRating, setMinRating] = useState<number>(0);
  const [maxPrice, setMaxPrice] = useState<number>(5000);

  useEffect(() => {
    supabase
      .from("service_providers")
      .select("*")
      .eq("verification_status", "verified")
      .then(({ data }) => {
        setProviders(data ?? []);
        setLoading(false);
      });
  }, []);

  // Get unique categories
  const categories = Array.from(new Set(providers.map((p) => p.category))).sort();

  const filtered = providers.filter((p) => {
    const matchesSearch =
      !q ||
      p.business_name.toLowerCase().includes(q.toLowerCase()) ||
      p.category.toLowerCase().includes(q.toLowerCase()) ||
      (p.location ?? "").toLowerCase().includes(q.toLowerCase());

    const matchesCategory = selectedCategory === "all" || p.category === selectedCategory;
    const matchesRating = (p.avg_rating ?? 0) >= minRating;
    const matchesPrice = !p.hourly_rate || p.hourly_rate <= maxPrice;

    return matchesSearch && matchesCategory && matchesRating && matchesPrice;
  });

  const clearFilters = () => {
    setQ("");
    setSelectedCategory("all");
    setMinRating(0);
    setMaxPrice(5000);
  };

  const hasActiveFilters = q || selectedCategory !== "all" || minRating > 0 || maxPrice < 5000;

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />
      <main className="flex-1">
        <section className="bg-white">
          <div className="mx-auto max-w-5xl px-4 py-8 sm:py-12">
            <h1 className="text-2xl sm:text-3xl md:text-4xl font-bold tracking-tight">
              Verified providers
            </h1>
            <p className="mt-2 text-sm sm:text-base text-muted-foreground">
              All providers below have passed document verification.
            </p>
            <div className="mt-6 space-y-4">
              <div className="flex gap-2">
                <Input
                  value={q}
                  onChange={(e) => setQ(e.target.value)}
                  placeholder="Search by name, category, location"
                  className="flex-1"
                />
                <Button
                  variant="outline"
                  onClick={() => setShowFilters(!showFilters)}
                  className={showFilters ? "bg-primary/10" : ""}
                >
                  <Filter className="w-4 h-4 mr-2" />
                  Filters
                </Button>
                {hasActiveFilters && (
                  <Button variant="ghost" onClick={clearFilters}>
                    <X className="w-4 h-4 mr-2" />
                    Clear
                  </Button>
                )}
              </div>

              {showFilters && (
                <Card className="p-4 space-y-4">
                  <div className="grid gap-4 sm:grid-cols-2 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label>Category</Label>
                      <Select value={selectedCategory} onValueChange={setSelectedCategory}>
                        <SelectTrigger>
                          <SelectValue placeholder="All categories" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="all">All categories</SelectItem>
                          {categories.map((cat) => (
                            <SelectItem key={cat} value={cat}>
                              {cat}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>

                    <div className="space-y-2">
                      <Label>Minimum Rating</Label>
                      <Select
                        value={minRating.toString()}
                        onValueChange={(v) => setMinRating(parseFloat(v))}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Any rating" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="0">Any rating</SelectItem>
                          <SelectItem value="3">3+ stars</SelectItem>
                          <SelectItem value="4">4+ stars</SelectItem>
                          <SelectItem value="4.5">4.5+ stars</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>

                    <div className="space-y-2 sm:col-span-2 md:col-span-1">
                      <Label>Max Hourly Rate</Label>
                      <Select
                        value={maxPrice.toString()}
                        onValueChange={(v) => setMaxPrice(parseFloat(v))}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Any price" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="5000">Any price</SelectItem>
                          <SelectItem value="500">Under R500/hr</SelectItem>
                          <SelectItem value="1000">Under R1000/hr</SelectItem>
                          <SelectItem value="2000">Under R2000/hr</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </Card>
              )}
            </div>
          </div>
        </section>

        <section className="mx-auto max-w-5xl px-4 py-10">
          {loading ? (
            <p className="text-sm text-muted-foreground">Loading…</p>
          ) : filtered.length === 0 ? (
            <Card className="p-12 text-center">
              <p className="text-muted-foreground">
                No providers found yet. Be the first to{" "}
                <a href="/auth" className="text-primary underline">
                  register as a provider
                </a>
                .
              </p>
            </Card>
          ) : (
            <div className="grid gap-4 md:grid-cols-2">
              {filtered.map((p) => (
                <Card key={p.id} className="p-5 shadow-card transition-smooth hover:shadow-soft">
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <div className="flex items-center gap-2">
                        <h3 className="font-semibold">{p.business_name}</h3>
                      </div>
                      <Badge variant="secondary" className="mt-1">
                        {p.category}
                      </Badge>
                    </div>
                    <div className="text-right">
                      <div className="flex items-center gap-1 text-sm">
                        <span className="font-medium">{(p.avg_rating ?? 0).toFixed(1)}</span>
                        <span className="text-muted-foreground">({p.rating_count ?? 0})</span>
                      </div>
                      {p.hourly_rate && (
                        <p className="mt-1 text-xs text-muted-foreground">R{p.hourly_rate}/hr</p>
                      )}
                    </div>
                  </div>
                  {p.bio && (
                    <p className="mt-3 line-clamp-2 text-sm text-muted-foreground">{p.bio}</p>
                  )}
                  {p.location && <p className="mt-3 text-xs text-muted-foreground">{p.location}</p>}
                </Card>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}
