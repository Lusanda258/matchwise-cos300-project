import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Search, Inbox, FileText, User, MessageSquare } from "lucide-react";

interface EmptyStateProps {
  icon?: "search" | "inbox" | "file" | "user" | "message";
  title: string;
  description: string;
  action?: {
    label: string;
    onClick: () => void;
  };
}

const iconMap = {
  search: Search,
  inbox: Inbox,
  file: FileText,
  user: User,
  message: MessageSquare,
};

export function EmptyState({ icon = "inbox", title, description, action }: EmptyStateProps) {
  const Icon = iconMap[icon];

  return (
    <Card className="flex flex-col items-center justify-center p-12 text-center border-dashed">
      <div className="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-muted">
        <Icon className="h-8 w-8 text-muted-foreground" />
      </div>
      <h3 className="text-lg font-semibold mb-2">{title}</h3>
      <p className="text-sm text-muted-foreground mb-6 max-w-sm">{description}</p>
      {action && (
        <Button onClick={action.onClick} className="bg-gradient-hero text-white">
          {action.label}
        </Button>
      )}
    </Card>
  );
}