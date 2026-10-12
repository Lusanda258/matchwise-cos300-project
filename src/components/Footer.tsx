import { Link } from "@tanstack/react-router";
import { Sparkles, Shield, Heart } from "lucide-react";

export function Footer() {
  return (
    <footer className="border-t border-border/60 bg-muted/30 mt-auto">
      <div className="mx-auto max-w-6xl px-4 py-8">
        <div className="flex flex-col items-center gap-4 text-center">
          {/* Brand */}
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-hero text-white shadow-lg">
              <Sparkles className="w-4 h-4" />
            </div>
            <span className="text-lg font-bold text-gradient">MatchWise</span>
          </div>
          
          <p className="text-sm text-muted-foreground max-w-md">
            AI-powered platform connecting clients with verified service providers.
          </p>

          {/* Links */}
          <div className="flex flex-wrap justify-center gap-4 text-sm text-muted-foreground">
            <Link to="/" className="hover:text-foreground transition-smooth font-medium">Home</Link>
            <Link to="/how-it-works" className="hover:text-foreground transition-smooth font-medium">How it works</Link>
            <Link to="/providers" className="hover:text-foreground transition-smooth font-medium">Providers</Link>
            <Link to="/auth" className="hover:text-foreground transition-smooth font-medium">Sign up</Link>
          </div>

          {/* Bottom info */}
          <div className="flex flex-col items-center gap-2 text-sm text-muted-foreground pt-4 border-t border-border/60 w-full">
            <div className="flex items-center gap-2">
              <Shield className="w-4 h-4 text-primary" />
              <span>All providers are verified and background-checked</span>
            </div>
            <div className="flex items-center gap-2">
              <Heart className="w-4 h-4 text-primary" />
              <p>{new Date().getFullYear()} MatchWise · Built with care</p>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
