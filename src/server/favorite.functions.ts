import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";

const AddFavoriteSchema = z.object({
  provider_id: z.string().uuid(),
});

const RemoveFavoriteSchema = z.object({
  provider_id: z.string().uuid(),
});

export const addFavoriteProvider = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => AddFavoriteSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Check if already favorited
    const { data: existingFavorite } = await supabase
      .from("favorite_providers")
      .select("*")
      .eq("client_id", userId)
      .eq("provider_id", data.provider_id)
      .single();

    if (existingFavorite) {
      throw new Error("Provider already in favorites");
    }

    // Add to favorites
    const { error: insertErr } = await supabase
      .from("favorite_providers")
      .insert({
        client_id: userId,
        provider_id: data.provider_id,
      });

    if (insertErr) throw new Error(insertErr.message);

    return { success: true };
  });

export const removeFavoriteProvider = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => RemoveFavoriteSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Remove from favorites
    const { error: deleteErr } = await supabase
      .from("favorite_providers")
      .delete()
      .eq("client_id", userId)
      .eq("provider_id", data.provider_id);

    if (deleteErr) throw new Error(deleteErr.message);

    return { success: true };
  });

export const getFavoriteProviders = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: favorites, error } = await supabase
      .from("favorite_providers")
      .select(`
        provider_id,
        created_at,
        service_providers (
          id,
          business_name,
          category,
          location,
          avg_rating,
          rating_count,
          hourly_rate,
          verification_status
        )
      `)
      .eq("client_id", userId)
      .order("created_at", { ascending: false });

    if (error) throw new Error(error.message);

    return favorites;
  });

export const isProviderFavorited = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => AddFavoriteSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: favorite, error } = await supabase
      .from("favorite_providers")
      .select("*")
      .eq("client_id", userId)
      .eq("provider_id", data.provider_id)
      .single();

    if (error && error.code !== "PGRST116") {
      // PGRST116 is "not found" error, which is expected
      throw new Error(error.message);
    }

    return { isFavorited: !!favorite };
  });
