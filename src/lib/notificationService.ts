import { supabase } from "@/integrations/supabase/client";
import type { Database } from "@/integrations/supabase/types";

type Notification = Database["public"]["Tables"]["notifications"]["Row"];

export type { Notification };

// Get all notifications for the current user
export async function getUserNotifications(): Promise<Notification[]> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data, error } = await supabase
    .from("notifications")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching notifications:", error);
    return [];
  }

  return data || [];
}

// Get unread notification count
export async function getUnreadNotificationCount(): Promise<number> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return 0;

  const { count, error } = await supabase
    .from("notifications")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user.id)
    .eq("read", false);

  if (error) {
    console.error("Error fetching notification count:", error);
    return 0;
  }

  return count || 0;
}

// Mark a notification as read
export async function markNotificationAsRead(notificationId: string): Promise<boolean> {
  const { error } = await supabase.rpc("mark_notification_as_read", {
    notification_id: notificationId
  });

  if (error) {
    console.error("Error marking notification as read:", error);
    return false;
  }

  return true;
}

// Mark all notifications as read
export async function markAllNotificationsAsRead(): Promise<number> {
  const { data, error } = await supabase.rpc("mark_all_notifications_as_read");

  if (error) {
    console.error("Error marking all notifications as read:", error);
    return 0;
  }

  return data || 0;
}

// Delete a notification
export async function deleteNotification(notificationId: string): Promise<boolean> {
  const { error } = await supabase.rpc("delete_notification", {
    notification_id: notificationId
  });

  if (error) {
    console.error("Error deleting notification:", error);
    return false;
  }

  return true;
}

// Clear all notifications
export async function clearAllNotifications(): Promise<number> {
  const { data, error } = await supabase.rpc("clear_all_notifications");

  if (error) {
    console.error("Error clearing notifications:", error);
    return 0;
  }

  return data || 0;
}

// Create a notification (server-side only)
export async function createNotification(
  userId: string,
  type: "success" | "error" | "warning" | "info",
  title: string,
  message: string,
  metadata: Record<string, any> = {}
): Promise<string | null> {
  const { data, error } = await supabase.rpc("create_notification", {
    p_user_id: userId,
    p_type: type,
    p_title: title,
    p_message: message,
    p_metadata: metadata
  });

  if (error) {
    console.error("Error creating notification:", error);
    return null;
  }

  return data;
}

// Subscribe to real-time notification updates
export function subscribeToNotifications(
  callback: (notification: Notification) => void
) {
  const channel = supabase
    .channel("notifications")
    .on(
      "postgres_changes",
      {
        event: "INSERT",
        schema: "public",
        table: "notifications",
      },
      (payload) => {
        callback(payload.new as Notification);
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
}