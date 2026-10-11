import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { Bell, Volume2, VolumeX, MessageSquare, Mail, CheckCircle2, Sparkles, Info } from "lucide-react";

interface NotificationPreferences {
  inApp: boolean;
  email: boolean;
  push: boolean;
  sound: boolean;
  volume: number;
  categories: {
    matches: boolean;
    messages: boolean;
    updates: boolean;
    promotions: boolean;
  };
}

export function NotificationPreferences() {
  const [preferences, setPreferences] = useState<NotificationPreferences>({
    inApp: true,
    email: true,
    push: false,
    sound: true,
    volume: 0.5,
    categories: {
      matches: true,
      messages: true,
      updates: true,
      promotions: false,
    },
  });

  const updatePreference = <K extends keyof NotificationPreferences>(
    key: K,
    value: NotificationPreferences[K]
  ) => {
    setPreferences(prev => ({ ...prev, [key]: value }));
  };

  const updateCategory = (category: keyof NotificationPreferences["categories"], value: boolean) => {
    setPreferences(prev => ({
      ...prev,
      categories: { ...prev.categories, [category]: value },
    }));
  };

  const savePreferences = () => {
    // In a real app, this would save to a database
    console.log("Saving preferences:", preferences);
    // Show success notification
  };

  return (
    <Card className="p-6">
      <div className="flex items-center gap-2 mb-6">
        <Bell className="h-5 w-5 text-primary" />
        <h3 className="text-lg font-semibold">Notification Preferences</h3>
      </div>

      {/* Delivery Methods */}
      <div className="space-y-4 mb-6">
        <h4 className="text-sm font-medium text-muted-foreground">Delivery Methods</h4>
        
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Bell className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="in-app">In-App Notifications</Label>
          </div>
          <Switch
            id="in-app"
            checked={preferences.inApp}
            onCheckedChange={(checked) => updatePreference("inApp", checked)}
          />
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Mail className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="email">Email Notifications</Label>
          </div>
          <Switch
            id="email"
            checked={preferences.email}
            onCheckedChange={(checked) => updatePreference("email", checked)}
          />
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <CheckCircle2 className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="push">Push Notifications</Label>
          </div>
          <Switch
            id="push"
            checked={preferences.push}
            onCheckedChange={(checked) => updatePreference("push", checked)}
          />
        </div>
      </div>

      {/* Sound Settings */}
      <div className="space-y-4 mb-6">
        <h4 className="text-sm font-medium text-muted-foreground">Sound Settings</h4>
        
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            {preferences.sound ? (
              <Volume2 className="h-4 w-4 text-muted-foreground" />
            ) : (
              <VolumeX className="h-4 w-4 text-muted-foreground" />
            )}
            <Label htmlFor="sound">Notification Sounds</Label>
          </div>
          <Switch
            id="sound"
            checked={preferences.sound}
            onCheckedChange={(checked) => updatePreference("sound", checked)}
          />
        </div>

        {preferences.sound && (
          <div className="flex items-center gap-3">
            <Volume2 className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="volume">Volume</Label>
            <input
              id="volume"
              type="range"
              min="0"
              max="1"
              step="0.1"
              value={preferences.volume}
              onChange={(e) => updatePreference("volume", parseFloat(e.target.value))}
              className="flex-1 h-2 bg-muted rounded-lg appearance-none cursor-pointer"
            />
            <Badge variant="outline" className="w-12 text-center">
              {Math.round(preferences.volume * 100)}%
            </Badge>
          </div>
        )}
      </div>

      {/* Notification Categories */}
      <div className="space-y-4 mb-6">
        <h4 className="text-sm font-medium text-muted-foreground">Notification Categories</h4>
        
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Sparkles className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="matches">New Matches</Label>
          </div>
          <Switch
            id="matches"
            checked={preferences.categories.matches}
            onCheckedChange={(checked) => updateCategory("matches", checked)}
          />
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <MessageSquare className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="messages">Messages</Label>
          </div>
          <Switch
            id="messages"
            checked={preferences.categories.messages}
            onCheckedChange={(checked) => updateCategory("messages", checked)}
          />
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Info className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="updates">System Updates</Label>
          </div>
          <Switch
            id="updates"
            checked={preferences.categories.updates}
            onCheckedChange={(checked) => updateCategory("updates", checked)}
          />
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Sparkles className="h-4 w-4 text-muted-foreground" />
            <Label htmlFor="promotions">Promotions</Label>
          </div>
          <Switch
            id="promotions"
            checked={preferences.categories.promotions}
            onCheckedChange={(checked) => updateCategory("promotions", checked)}
          />
        </div>
      </div>

      <Button onClick={savePreferences} className="w-full bg-gradient-hero text-white">
        Save Preferences
      </Button>
    </Card>
  );
}