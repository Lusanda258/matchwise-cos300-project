import { toast } from "sonner";
import { CheckCircle2, XCircle, AlertCircle, Info, Sparkles, MessageSquare, Shield, Clock } from "lucide-react";
import { createNotification as createDbNotification } from "./notificationService";

// Notification types
export type NotificationType = "success" | "error" | "warning" | "info" | "loading";

// Notification presets for common actions
export const notifications = {
  // Success notifications
  success: {
    message: (message: string) => toast.success(message, {
      icon: <CheckCircle2 className="text-success" />,
    }),
    login: () => toast.success("Welcome back! You're now logged in.", {
      icon: <CheckCircle2 className="text-success" />,
    }),
    logout: () => toast.success("You've been logged out successfully.", {
      icon: <CheckCircle2 className="text-success" />,
    }),
    signup: () => toast.success("Account created successfully! Welcome to MatchWise.", {
      icon: <Sparkles className="text-primary" />,
    }),
    matchFound: (providerName: string) => 
      toast.success(`Great match! We found ${providerName} for you.`, {
        icon: <Sparkles className="text-primary" />,
      }),
    messageSent: () => toast.success("Message sent successfully!", {
      icon: <MessageSquare className="text-primary" />,
    }),
    inquirySent: () => toast.success("Inquiry sent! The provider will respond soon.", {
      icon: <MessageSquare className="text-primary" />,
    }),
    reportSubmitted: () => toast.success("Report submitted. We'll review it shortly.", {
      icon: <Shield className="text-success" />,
    }),
    profileUpdated: () => toast.success("Profile updated successfully!", {
      icon: <CheckCircle2 className="text-success" />,
    }),
    settingsSaved: () => toast.success("Settings saved successfully!", {
      icon: <CheckCircle2 className="text-success" />,
    }),
  },

  // Error notifications
  error: {
    message: (message: string) => toast.error(message, {
      icon: <XCircle className="text-destructive" />,
    }),
    loginFailed: () => toast.error("Login failed. Please check your credentials.", {
      icon: <XCircle className="text-destructive" />,
    }),
    signupFailed: () => toast.error("Sign up failed. Please try again.", {
      icon: <XCircle className="text-destructive" />,
    }),
    networkError: () => toast.error("Network error. Please check your connection.", {
      icon: <XCircle className="text-destructive" />,
    }),
    noMatches: () => toast.error("No matches found. Try adjusting your search criteria.", {
      icon: <XCircle className="text-destructive" />,
    }),
    uploadFailed: () => toast.error("Upload failed. Please try again.", {
      icon: <XCircle className="text-destructive" />,
    }),
    validationError: (field: string) => 
      toast.error(`Please check your ${field} and try again.`, {
        icon: <XCircle className="text-destructive" />,
      }),
  },

  // Warning notifications
  warning: {
    message: (message: string) => toast.warning(message, {
      icon: <AlertCircle className="text-warning" />,
    }),
    sessionExpiring: () => toast.warning("Your session will expire soon. Please refresh.", {
      icon: <Clock className="text-warning" />,
    }),
    incompleteProfile: () => toast.warning("Complete your profile to get better matches.", {
      icon: <AlertCircle className="text-warning" />,
    }),
    rateLimit: () => toast.warning("You've reached the rate limit. Please wait a moment.", {
      icon: <AlertCircle className="text-warning" />,
    }),
  },

  // Info notifications
  info: {
    message: (message: string) => toast.info(message, {
      icon: <Info className="text-primary" />,
    }),
    newMessage: (sender: string) => 
      toast.info(`New message from ${sender}`, {
        icon: <MessageSquare className="text-primary" />,
      }),
    newMatch: () => toast.info("New provider match available!", {
      icon: <Sparkles className="text-primary" />,
    }),
    systemUpdate: () => toast.info("System update available. Check for new features.", {
      icon: <Info className="text-primary" />,
    }),
  },

  // Loading notifications
  loading: {
    message: (message: string) => toast.loading(message),
    searching: () => toast.loading("Searching for the best matches..."),
    uploading: () => toast.loading("Uploading your file..."),
    processing: () => toast.loading("Processing your request..."),
    connecting: () => toast.loading("Connecting to provider..."),
  },
};

// Custom notification with action
export const notificationWithAction = (
  message: string,
  actionLabel: string,
  action: () => void,
  type: NotificationType = "info"
) => {
  const icons = {
    success: <CheckCircle2 className="text-success" />,
    error: <XCircle className="text-destructive" />,
    warning: <AlertCircle className="text-warning" />,
    info: <Info className="text-primary" />,
    loading: <Clock className="text-primary" />,
  };

  toast(message, {
    icon: icons[type],
    action: {
      label: actionLabel,
      onClick: action,
    },
  });
};

// Dismissible notification
export const dismissibleNotification = (
  message: string,
  type: NotificationType = "info"
) => {
  const icons = {
    success: <CheckCircle2 className="text-success" />,
    error: <XCircle className="text-destructive" />,
    warning: <AlertCircle className="text-warning" />,
    info: <Info className="text-primary" />,
    loading: <Clock className="text-primary" />,
  };

  toast(message, {
    icon: icons[type],
    dismissible: true,
  });
};

// Promise notification (for async operations)
export const promiseNotification = <T,>(
  promise: Promise<T>,
  {
    loading,
    success,
    error,
  }: {
    loading: string;
    success: string | ((data: T) => string);
    error: string | ((error: Error) => string);
  }
) => {
  return toast.promise(promise, {
    loading,
    success: (data) => typeof success === "function" ? success(data) : success,
    error: (err) => typeof error === "function" ? error(err) : error,
  });
};

// Create notification with both toast and database storage
export const createSystemNotification = async (
  type: NotificationType,
  title: string,
  message: string,
  userId?: string
) => {
  // Show toast notification
  const toastFn = type === "success" ? toast.success :
                  type === "error" ? toast.error :
                  type === "warning" ? toast.warning : toast.info;
  
  toastFn(message);

  // Store in database (if userId is provided)
  if (userId) {
    try {
      await createDbNotification(userId, type, title, message);
    } catch (error) {
      console.error("Failed to create database notification:", error);
    }
  }
};