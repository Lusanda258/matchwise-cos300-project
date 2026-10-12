import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const SubmitSupportSchema = z.object({
  subject: z.string().min(5, "Subject must be at least 5 characters"),
  message: z.string().min(10, "Message must be at least 10 characters"),
  priority: z.enum(["low", "medium", "high", "urgent"]).default("medium"),
});

const RespondSupportSchema = z.object({
  id: z.string().uuid(),
  response: z.string().min(1, "Response cannot be empty"),
  status: z.enum(["in_progress", "resolved", "dismissed"]).default("resolved"),
});

const UpdateStatusSchema = z.object({
  id: z.string().uuid(),
  status: z.enum(["pending", "in_progress", "resolved", "dismissed"]),
});

// Submit a support message
export const submitSupportMessage = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => SubmitSupportSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { userId } = context;

    // Create support message using admin client to bypass RLS
    const { data: insertData, error } = await supabaseAdmin
      .from("support_messages")
      .insert({
        user_id: userId,
        subject: data.subject,
        message: data.message,
        priority: data.priority,
      })
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to submit support message: ${error.message}`);
    }

    return insertData;
  });

// Get all support messages (admin only)
export const getSupportMessages = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    // Verify user is admin
    const { data: userRole } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", userId)
      .eq("role", "admin")
      .maybeSingle();

    if (!userRole) {
      throw new Error("Only admins can view support messages");
    }

    // Get all support messages with user info using admin client to bypass RLS
    const { data: messagesData, error } = await supabaseAdmin
      .from("support_messages")
      .select(
        `
        *,
        user:profiles!user_id(id, full_name, email),
        admin:profiles!admin_id(id, full_name)
      `,
    )
      .order("created_at", { ascending: false });

    if (error) {
      throw new Error(`Failed to fetch support messages: ${error.message}`);
    }

    return messagesData;
  });

// Get user's own support messages
export const getUserSupportMessages = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { userId } = context;

    const { data: userMessagesData, error } = await supabaseAdmin
      .from("support_messages")
      .select("*")
      .eq("user_id", userId)
      .order("created_at", { ascending: false });

    if (error) {
      throw new Error(`Failed to fetch support messages: ${error.message}`);
    }

    return userMessagesData;
  });

// Respond to a support message (admin only)
export const respondToSupportMessage = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => RespondSupportSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Verify user is admin
    const { data: userRole } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", userId)
      .eq("role", "admin")
      .maybeSingle();

    if (!userRole) {
      throw new Error("Only admins can respond to support messages");
    }

    // Update support message using admin client to bypass RLS
    const { data: updated, error } = await supabaseAdmin
      .from("support_messages")
      .update({
        admin_response: data.response,
        status: data.status,
        admin_id: userId,
      })
      .eq("id", data.id)
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to respond to support message: ${error.message}`);
    }

    return updated;
  });

// Update support message status (admin only)
export const updateSupportMessageStatus = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => UpdateStatusSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Verify user is admin
    const { data: userRole } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", userId)
      .eq("role", "admin")
      .maybeSingle();

    if (!userRole) {
      throw new Error("Only admins can update support message status");
    }

    const { data: updated, error } = await supabaseAdmin
      .from("support_messages")
      .update({ status: data.status })
      .eq("id", data.id)
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to update support message status: ${error.message}`);
    }

    return updated;
  });
