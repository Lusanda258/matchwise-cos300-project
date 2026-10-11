import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const MAX_ATTEMPTS = 5;
const LOCKOUT_DURATION_MINUTES = 15;

const CheckLockoutSchema = z.object({
  email: z.string().email(),
});

const RecordFailedAttemptSchema = z.object({
  email: z.string().email(),
});

const ResetFailedAttemptsSchema = z.object({
  email: z.string().email(),
});

// Check if an email is currently locked out
export const checkAccountLockout = createServerFn({ method: "POST" })
  .inputValidator((input: unknown) => CheckLockoutSchema.parse(input))
  .handler(async ({ data }) => {
    const { email } = data;

    try {
      console.log("Checking lockout for email:", email);

      const { data: record, error } = await supabaseAdmin
        .from("failed_login_attempts")
        .select("*")
        .eq("email", email.toLowerCase())
        .maybeSingle();

      console.log("Lockout check result:", { record, error });

      if (error) {
        // If table doesn't exist, treat as not locked
        if (error.code === '42P01') {
          console.warn("failed_login_attempts table does not exist. Lockout feature disabled.");
          return { isLocked: false, attempts: 0, lockedUntil: null };
        }
        console.error("Error checking lockout:", error);
        return { isLocked: false, attempts: 0, lockedUntil: null };
      }

      if (!record) {
        console.log("No record found for email:", email);
        return { isLocked: false, attempts: 0, lockedUntil: null };
      }

      // Check if lockout has expired
      if (record.locked_until && new Date(record.locked_until) > new Date()) {
        console.log("Account is locked until:", record.locked_until);
        return {
          isLocked: true,
          attempts: record.attempt_count,
          lockedUntil: record.locked_until,
        };
      }

      // Lockout has expired, reset attempts
      if (record.locked_until && new Date(record.locked_until) <= new Date()) {
        console.log("Lockout expired, resetting attempts");
        await supabaseAdmin
          .from("failed_login_attempts")
          .update({ attempt_count: 0, locked_until: null })
          .eq("email", email.toLowerCase());

        return { isLocked: false, attempts: 0, lockedUntil: null };
      }

      console.log("Account not locked, current attempts:", record.attempt_count);
      return {
        isLocked: false,
        attempts: record.attempt_count,
        lockedUntil: null,
      };
    } catch (error) {
      console.error("Unexpected error checking lockout:", error);
      return { isLocked: false, attempts: 0, lockedUntil: null };
    }
  });

// Record a failed login attempt
export const recordFailedLoginAttempt = createServerFn({ method: "POST" })
  .inputValidator((input: unknown) => RecordFailedAttemptSchema.parse(input))
  .handler(async ({ data }) => {
    const { email } = data;

    try {
      console.log("Recording failed attempt for email:", email);
      const emailLower = email.toLowerCase();
      console.log("Email (lowercase):", emailLower);

      const { data: record, error: fetchError } = await supabaseAdmin
        .from("failed_login_attempts")
        .select("*")
        .eq("email", emailLower)
        .maybeSingle();

      console.log("Fetch result:", { record, fetchError, emailLower });

      // If table doesn't exist, just return without recording
      if (fetchError && fetchError.code === '42P01') {
        console.warn("failed_login_attempts table does not exist. Lockout feature disabled.");
        return {
          attempts: 1,
          isLocked: false,
          lockedUntil: null,
          remainingAttempts: MAX_ATTEMPTS - 1,
        };
      }

      if (fetchError) {
        console.error("Error fetching failed attempts:", fetchError);
        console.error("Error details:", JSON.stringify(fetchError, null, 2));
        return {
          attempts: 1,
          isLocked: false,
          lockedUntil: null,
          remainingAttempts: MAX_ATTEMPTS - 1,
        };
      }

      const newAttemptCount = (record?.attempt_count || 0) + 1;
      const lockedUntil =
        newAttemptCount >= MAX_ATTEMPTS
          ? new Date(Date.now() + LOCKOUT_DURATION_MINUTES * 60 * 1000).toISOString()
          : null;

      console.log("New attempt count:", newAttemptCount, "Current record attempt count:", record?.attempt_count, "Is locked:", newAttemptCount >= MAX_ATTEMPTS);

      if (record) {
        // Update existing record
        console.log("Updating existing record for email:", emailLower);
        const { error, data: updateData } = await supabaseAdmin
          .from("failed_login_attempts")
          .update({
            attempt_count: newAttemptCount,
            last_attempt_at: new Date().toISOString(),
            locked_until: lockedUntil,
          })
          .eq("email", emailLower)
          .select();

        if (error) {
          console.error("Error recording failed attempt:", error);
          console.error("Error details:", JSON.stringify(error, null, 2));
        } else {
          console.log("Successfully updated failed attempt count. Updated data:", updateData);
        }
      } else {
        // Create new record
        console.log("Creating new record for email:", emailLower);
        const { error, data: insertData } = await supabaseAdmin
          .from("failed_login_attempts")
          .insert({
            email: emailLower,
            attempt_count: newAttemptCount,
            last_attempt_at: new Date().toISOString(),
            locked_until: lockedUntil,
          })
          .select();

        if (error) {
          console.error("Error recording failed attempt:", error);
          console.error("Error details:", JSON.stringify(error, null, 2));
        } else {
          console.log("Successfully created new failed attempt record. Inserted data:", insertData);
        }
      }

      return {
        attempts: newAttemptCount,
        isLocked: newAttemptCount >= MAX_ATTEMPTS,
        lockedUntil,
        remainingAttempts: MAX_ATTEMPTS - newAttemptCount,
      };
    } catch (error) {
      console.error("Unexpected error recording failed attempt:", error);
      console.error("Error stack:", error instanceof Error ? error.stack : 'No stack');
      return {
        attempts: 1,
        isLocked: false,
        lockedUntil: null,
        remainingAttempts: MAX_ATTEMPTS - 1,
      };
    }
  });

// Reset failed login attempts after successful login
export const resetFailedLoginAttempts = createServerFn({ method: "POST" })
  .inputValidator((input: unknown) => ResetFailedAttemptsSchema.parse(input))
  .handler(async ({ data }) => {
    const { email } = data;

    try {
      const { error } = await supabaseAdmin
        .from("failed_login_attempts")
        .delete()
        .eq("email", email.toLowerCase());

      if (error) {
        // If table doesn't exist, that's fine
        if (error.code !== '42P01') {
          console.error("Error resetting failed attempts:", error);
        }
      }

      return { success: true };
    } catch (error) {
      console.error("Unexpected error resetting failed attempts:", error);
      return { success: true };
    }
  });
