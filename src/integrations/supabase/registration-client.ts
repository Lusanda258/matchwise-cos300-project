// External Supabase client for business registration verification database
import { createClient } from '@supabase/supabase-js';

function createRegistrationClient() {
  // Use import.meta.env for client-side (Vite build-time replacement)
  // Fall back to process.env for SSR (server-side rendering)
  const REGISTRATION_SUPABASE_URL = import.meta.env.VITE_REGISTRATION_SUPABASE_URL || process.env.REGISTRATION_SUPABASE_URL;
  const REGISTRATION_SUPABASE_KEY = import.meta.env.VITE_REGISTRATION_SUPABASE_KEY || process.env.REGISTRATION_SUPABASE_KEY;

  // Check if the credentials are properly configured (not placeholder values)
  if (!REGISTRATION_SUPABASE_URL || !REGISTRATION_SUPABASE_KEY || 
      REGISTRATION_SUPABASE_URL.includes('your-external-supabase-url') || 
      REGISTRATION_SUPABASE_KEY.includes('your-external-supabase-anon-key')) {
    const message = 'External registration database not configured. Please set REGISTRATION_SUPABASE_URL and REGISTRATION_SUPABASE_KEY in your environment variables.';
    console.warn(`[RegistrationSupabase] ${message}`);
    return null;
  }

  return createClient(REGISTRATION_SUPABASE_URL, REGISTRATION_SUPABASE_KEY, {
    auth: {
      storage: typeof window !== 'undefined' ? localStorage : undefined,
      persistSession: true,
      autoRefreshToken: true,
    }
  });
}

let _registrationSupabase: ReturnType<typeof createRegistrationClient> | null = null;

// Import the registration supabase client like this:
// import { registrationSupabase } from "@/integrations/supabase/registration-client";

export const registrationSupabase = new Proxy(
  {} as ReturnType<typeof createRegistrationClient>,
  {
    get(_, prop, receiver) {
      if (_registrationSupabase === null) {
        _registrationSupabase = createRegistrationClient();
      }

      if (!_registrationSupabase) {
        throw new Error('External registration database not configured. Please set REGISTRATION_SUPABASE_URL and REGISTRATION_SUPABASE_KEY in your environment variables.');
      }

      return Reflect.get(_registrationSupabase, prop, receiver);
    },
  }
);

// Export a typed wrapper for the from method to avoid TypeScript issues
export const from = (table: string) => {
  const client = registrationSupabase as any;
  if (!client) {
    throw new Error('External registration database not configured. Please set REGISTRATION_SUPABASE_URL and REGISTRATION_SUPABASE_KEY in your environment variables.');
  }
  return client.from(table);
};
