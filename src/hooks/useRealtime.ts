import { useEffect, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import type { RealtimeChannel } from "@supabase/supabase-js";

interface UseRealtimeSubscriptionOptions {
  table: string;
  filter?: string;
  onInsert?: (payload: any) => void;
  onUpdate?: (payload: any) => void;
  onDelete?: (payload: any) => void;
  enabled?: boolean;
}

export function useRealtimeSubscription({
  table,
  filter,
  onInsert,
  onUpdate,
  onDelete,
  enabled = true,
}: UseRealtimeSubscriptionOptions) {
  const channelRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!enabled) return;

    const channelName = `${table}-realtime-${Date.now()}`;
    
    const channel = supabase
      .channel(channelName)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table,
          filter,
        },
        (payload) => {
          switch (payload.eventType) {
            case "INSERT":
              onInsert?.(payload);
              break;
            case "UPDATE":
              onUpdate?.(payload);
              break;
            case "DELETE":
              onDelete?.(payload);
              break;
          }
        }
      )
      .subscribe((status) => {
        if (status === "SUBSCRIBED") {
          console.log(`[Realtime] Subscribed to ${table}`);
        } else if (status === "CHANNEL_ERROR") {
          console.error(`[Realtime] Error subscribing to ${table}`);
        }
      });

    channelRef.current = channel;

    return () => {
      if (channelRef.current) {
        supabase.removeChannel(channelRef.current);
        console.log(`[Realtime] Unsubscribed from ${table}`);
      }
    };
  }, [table, filter, onInsert, onUpdate, onDelete, enabled]);
}
