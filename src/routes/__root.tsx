import { Outlet, Link, createRootRoute, HeadContent, Scripts } from "@tanstack/react-router";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "sonner";
import { queryClient } from "@/lib/query-client";
import { OnboardingWrapper } from "@/components/OnboardingWrapper";

import appCss from "../styles.css?url";

function NotFoundComponent() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      <div className="max-w-md text-center">
        <h1 className="text-7xl font-bold text-foreground">404</h1>
        <h2 className="mt-4 text-xl font-semibold text-foreground">Page not found</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <div className="mt-6">
          <Link
            to="/"
            className="inline-flex items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
          >
            Go home
          </Link>
        </div>
      </div>
    </div>
  );
}

export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { title: "MatchWise — AI Smart Service Matching" },
      { name: "description", content: "Find verified, trusted service providers in seconds. AI matches your request with the best providers near you based on relevance, location, and ratings." },
      { name: "keywords", content: "service matching, AI provider matching, verified service providers, local services, professional services, smart matching" },
      { name: "author", content: "MatchWise" },
      { name: "robots", content: "index, follow" },
      { property: "og:title", content: "MatchWise — AI Smart Service Matching" },
      { property: "og:description", content: "AI-powered platform connecting clients with verified service providers. Smart matching based on your needs." },
      { property: "og:type", content: "website" },
      { property: "og:url", content: "https://matchwise.com" },
      { property: "og:image", content: "https://matchwise.com/og-image.png" },
      { property: "og:site_name", content: "MatchWise" },
      { name: "twitter:card", content: "summary_large_image" },
      { name: "twitter:site", content: "@matchwise" },
      { name: "twitter:creator", content: "@matchwise" },
      { name: "twitter:title", content: "MatchWise — AI Smart Service Matching" },
      { name: "twitter:description", content: "Find verified, trusted service providers in seconds. AI-powered smart matching." },
      { name: "twitter:image", content: "https://matchwise.com/twitter-image.png" },
    ],
    links: [
      {
        rel: "stylesheet",
        href: appCss,
      },
      {
        rel: "icon",
        type: "image/svg+xml",
        href: "/favicon.svg",
      },
    ],
  }),
  shellComponent: RootShell,
  component: RootComponent,
  notFoundComponent: NotFoundComponent,
});

function RootShell({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <HeadContent />
      </head>
      <body>
        <QueryClientProvider client={queryClient}>
          {children}
          <Toaster 
            position="top-center" 
            richColors 
            closeButton
            toastOptions={{
              style: {
                background: 'var(--color-card)',
                color: 'var(--color-foreground)',
                border: '1px solid var(--color-border)',
                borderRadius: 'var(--radius-lg)',
                boxShadow: 'var(--shadow-card)',
              },
              success: {
                iconTheme: {
                  primary: 'oklch(0.68 0.14 155)',
                  secondary: 'oklch(0.99 0 0)',
                },
              },
              error: {
                iconTheme: {
                  primary: 'oklch(0.6 0.22 25)',
                  secondary: 'oklch(0.99 0 0)',
                },
              },
              warning: {
                iconTheme: {
                  primary: 'oklch(0.78 0.15 75)',
                  secondary: 'oklch(0.25 0.05 60)',
                },
              },
              info: {
                iconTheme: {
                  primary: 'oklch(0.62 0.115 195)',
                  secondary: 'oklch(0.99 0.01 180)',
                },
              },
            }}
          />
        </QueryClientProvider>
        <Scripts />
      </body>
    </html>
  );
}

function RootComponent() {
  return (
    <OnboardingWrapper>
      <Outlet />
    </OnboardingWrapper>
  );
}
