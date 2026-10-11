import { useState, useEffect } from "react";
import { useNavigate } from "@tanstack/react-router";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Bell, X, CheckCircle2, XCircle, AlertCircle, Info, Sparkles, MessageSquare, Shield, Clock } from "lucide-react";
import { 
  getUserNotifications, 
  getUnreadNotificationCount,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotification as deleteDbNotification,
  clearAllNotifications,
  subscribeToNotifications,
  type Notification as DbNotification
} from "@/lib/notificationService";

interface Notification {
  id: string;
  type: "success" | "error" | "warning" | "info";
  title: string;
  message: string;
  timestamp: Date;
  read: boolean;
  metadata?: Record<string, any>;
}

export function NotificationCenter() {
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [loading, setLoading] = useState(true);

  // Load notifications on mount
  useEffect(() => {
    loadNotifications();
    
    // Subscribe to real-time updates
    const unsubscribe = subscribeToNotifications((newNotification) => {
      setNotifications(prev => [mapDbNotification(newNotification), ...prev]);
      setUnreadCount(prev => prev + 1);
    });

    return () => unsubscribe();
  }, []);

  const loadNotifications = async () => {
    setLoading(true);
    try {
      const [dbNotifications, count] = await Promise.all([
        getUserNotifications(),
        getUnreadNotificationCount()
      ]);
      setNotifications(dbNotifications.map(mapDbNotification));
      setUnreadCount(count);
    } catch (error) {
      console.error("Error loading notifications:", error);
    } finally {
      setLoading(false);
    }
  };

  const mapDbNotification = (dbNotif: DbNotification): Notification => ({
    id: dbNotif.id,
    type: dbNotif.type,
    title: dbNotif.title,
    message: dbNotif.message,
    timestamp: new Date(dbNotif.created_at),
    read: dbNotif.read,
    metadata: dbNotif.metadata,
  });

  const markAsRead = async (id: string) => {
    const success = await markNotificationAsRead(id);
    if (success) {
      setNotifications(prev => 
        prev.map(n => n.id === id ? { ...n, read: true } : n)
      );
      setUnreadCount(prev => Math.max(0, prev - 1));
    }
  };

  const markAllAsRead = async () => {
    const count = await markAllNotificationsAsRead();
    if (count > 0) {
      setNotifications(prev => 
        prev.map(n => ({ ...n, read: true }))
      );
      setUnreadCount(0);
    }
  };

  const handleDeleteNotification = async (id: string) => {
    const success = await deleteDbNotification(id);
    if (success) {
      setNotifications(prev => {
        const notification = prev.find(n => n.id === id);
        const newNotifications = prev.filter(n => n.id !== id);
        if (notification && !notification.read) {
          setUnreadCount(prev => Math.max(0, prev - 1));
        }
        return newNotifications;
      });
    }
  };

  const clearAll = async () => {
    const count = await clearAllNotifications();
    if (count > 0) {
      setNotifications([]);
      setUnreadCount(0);
    }
  };

  const handleNotificationClick = async (notification: Notification) => {
    // Mark as read
    await markAsRead(notification.id);
    
    // Navigate based on notification type and metadata
    if (notification.title === "New Message" && notification.metadata?.match_id) {
      navigate({ to: `/chat/${notification.metadata.match_id}` });
      setIsOpen(false);
    } else if (notification.title === "Request Accepted!" && notification.metadata?.match_id) {
      navigate({ to: `/chat/${notification.metadata.match_id}` });
      setIsOpen(false);
    } else if (notification.title === "New Service Request" && notification.metadata?.match_id) {
      navigate({ to: `/provider` });
      setIsOpen(false);
    }
  };

  const getIcon = (type: Notification["type"]) => {
    const icons = {
      success: <CheckCircle2 className="text-success" />,
      error: <XCircle className="text-destructive" />,
      warning: <AlertCircle className="text-warning" />,
      info: <Info className="text-primary" />,
    };
    return icons[type];
  };

  const formatTime = (date: Date) => {
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));

    if (minutes < 1) return "Just now";
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    return `${days}d ago`;
  };

  return (
    <div className="relative">
      <Button
        variant="ghost"
        size="icon"
        onClick={() => setIsOpen(!isOpen)}
        className="relative"
      >
        <Bell className="h-5 w-5" />
        {unreadCount > 0 && (
          <Badge className="absolute -top-1 -right-1 h-5 w-5 flex items-center justify-center p-0 bg-gradient-hero text-white">
            {unreadCount}
          </Badge>
        )}
      </Button>

      {isOpen && (
        <Card className="absolute right-0 top-12 w-80 max-h-96 overflow-hidden shadow-xl z-50">
          <div className="p-4 border-b border-border/60">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold">Notifications</h3>
              <div className="flex gap-2">
                {unreadCount > 0 && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={markAllAsRead}
                    className="text-xs"
                  >
                    Mark all read
                  </Button>
                )}
                {notifications.length > 0 && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={clearAll}
                    className="text-xs text-destructive"
                  >
                    Clear all
                  </Button>
                )}
              </div>
            </div>
          </div>

          <div className="overflow-y-auto max-h-80">
            {loading ? (
              <div className="p-8 text-center text-muted-foreground">
                <Clock className="h-8 w-8 mx-auto mb-2 opacity-50 animate-spin" />
                <p className="text-sm">Loading notifications...</p>
              </div>
            ) : notifications.length === 0 ? (
              <div className="p-8 text-center text-muted-foreground">
                <Bell className="h-8 w-8 mx-auto mb-2 opacity-50" />
                <p className="text-sm">No notifications</p>
              </div>
            ) : (
              notifications.map((notification) => (
                <div
                  key={notification.id}
                  className={`p-4 border-b border-border/40 hover:bg-muted/30 transition-smooth cursor-pointer ${
                    !notification.read ? "bg-primary/5" : ""
                  }`}
                  onClick={() => handleNotificationClick(notification)}
                >
                  <div className="flex gap-3">
                    <div className="flex-shrink-0 mt-0.5">
                      {getIcon(notification.type)}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2">
                        <h4 className="text-sm font-medium truncate">
                          {notification.title}
                        </h4>
                        <Button
                          variant="ghost"
                          size="icon"
                          className="h-4 w-4 flex-shrink-0"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleDeleteNotification(notification.id);
                          }}
                        >
                          <X className="h-3 w-3" />
                        </Button>
                      </div>
                      <p className="text-xs text-muted-foreground mt-1 line-clamp-2">
                        {notification.message}
                      </p>
                      <p className="text-xs text-muted-foreground mt-2">
                        {formatTime(notification.timestamp)}
                      </p>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </Card>
      )}
    </div>
  );
}