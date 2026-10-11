import { Link } from "@tanstack/react-router";
import { useAuth, signOut } from "@/lib/auth";
import { Button } from "@/components/ui/button";
import { NotificationCenter } from "@/components/NotificationCenter";
import { Sparkles, Menu, X, HelpCircle } from "lucide-react";
import { useState } from "react";

export function Navbar() {
  const { user, role, loading } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

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
    </header>
  );
}
