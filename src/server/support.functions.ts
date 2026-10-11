import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
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
  .inputValidator((input: unknown) => SubmitSupportSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { request } = context;
    const supabase = (await import("@/integrations/supabase/client.server")).supabase;

    // Get user from session
    const authHeader = request.headers.get("authorization");
    if (!authHeader) {
      throw new Error("Unauthorized");
    }

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
    } = await supabase.auth.getUser(token);

    if (!user) {
      throw new Error("Unauthorized");
    }

    // Create support message
    const { data: insertData, error } = await supabase
      .from("support_messages")
      .insert({
        user_id: user.id,
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
export const getSupportMessages = createServerFn({ method: "GET" }).handler(async ({ context }) => {
  const { request } = context;
  const supabase = (await import("@/integrations/supabase/client.server")).supabase;

  const authHeader = request.headers.get("authorization");
  if (!authHeader) {
    throw new Error("Unauthorized");
  }

  const token = authHeader.replace("Bearer ", "");
  const {
    data: { user },
  } = await supabase.auth.getUser(token);

  if (!user) {
    throw new Error("Unauthorized");
  }

  // Check if user is admin
  const { data: roleData } = await supabase
    .from("user_roles")
    .select("role")
    .eq("user_id", user.id)
    .eq("role", "admin")
    .single();

  if (!roleData) {
    throw new Error("Forbidden: Admin access required");
  }

  // Get all support messages with user info
  const { data: messagesData, error } = await supabase
    .from("support_messages")
    .select(
      `
        *,
        profiles (
          id,
          full_name,
          email
        )
      `,
    )
    .order("created_at", { ascending: false });

  if (error) {
    throw new Error(`Failed to fetch support messages: ${error.message}`);
  }

  return messagesData;
});

// Get user's own support messages
export const getUserSupportMessages = createServerFn({ method: "GET" }).handler(
  async ({ context }) => {
    const { request } = context;
    const supabase = (await import("@/integrations/supabase/client.server")).supabase;

    const authHeader = request.headers.get("authorization");
    if (!authHeader) {
      throw new Error("Unauthorized");
    }

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
    } = await supabase.auth.getUser(token);

    if (!user) {
      throw new Error("Unauthorized");
    }

    const { data: userMessagesData, error } = await supabase
      .from("support_messages")
      .select("*")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false });

    if (error) {
      throw new Error(`Failed to fetch support messages: ${error.message}`);
    }

    return userMessagesData;
  },
);

// Respond to a support message (admin only)
export const respondToSupportMessage = createServerFn({ method: "POST" })
  .inputValidator((input: unknown) => RespondSupportSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { request } = context;
    const supabase = (await import("@/integrations/supabase/client.server")).supabase;

    const authHeader = request.headers.get("authorization");
    if (!authHeader) {
      throw new Error("Unauthorized");
    }

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
    } = await supabase.auth.getUser(token);

    if (!user) {
      throw new Error("Unauthorized");
    }

    // Check if user is admin
    const { data: roleData } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", user.id)
      .eq("role", "admin")
      .single();

    if (!roleData) {
      throw new Error("Forbidden: Admin access required");
    }

    // Update support message
    const { data: updated, error } = await supabase
      .from("support_messages")
      .update({
        admin_response: data.response,
        status: data.status,
        admin_id: user.id,
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
  .inputValidator((input: unknown) => UpdateStatusSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { request } = context;
    const supabase = (await import("@/integrations/supabase/client.server")).supabase;

    const authHeader = request.headers.get("authorization");
    if (!authHeader) {
      throw new Error("Unauthorized");
    }

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
    } = await supabase.auth.getUser(token);

    if (!user) {
      throw new Error("Unauthorized");
    }

    // Check if user is admin
    const { data: roleData } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", user.id)
      .eq("role", "admin")
      .single();

    if (!roleData) {
      throw new Error("Forbidden: Admin access required");
    }

    const { data: updated, error } = await supabase
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
