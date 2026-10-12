import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Navbar } from "@/components/Navbar";
import { RoleGate } from "@/components/RoleGate";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogDescription,
} from "@/components/ui/dialog";
import { supabase } from "@/integrations/supabase/client";
import { registrationSupabase, from } from "@/integrations/supabase/registration-client";
import { getProviderReports, updateProviderReport } from "@/server/report.functions";
import {
  getSupportMessages,
  respondToSupportMessage,
  updateSupportMessageStatus,
} from "@/server/support.functions";
import { toast } from "sonner";
import { useRealtimeSubscription } from "@/hooks/useRealtime";

export const Route = createFileRoute("/admin")({
  component: () => (
    <RoleGate allow={["admin"]}>
      <AdminDashboard />
    </RoleGate>
  ),
  head: () => ({ meta: [{ title: "Admin dashboard — MatchWise" }] }),
});

interface ProviderRow {
  id: string;
  user_id: string;
  business_name: string;
  category: string;
  location: string | null;
  verification_status: string;
  business_registration_number?: string | null;
  documents?: DocRow[];
  reports?: ProviderReport[];
}
interface DocRow {
  id: string;
  provider_id: string;
  file_name: string;
  file_path: string;
  status: string;
}
interface ProviderReport {
  id: string;
  provider_id: string;
  match_id: string;
  client_id: string;
  report_text: string;
  status: "pending" | "reviewed" | "resolved" | "dismissed";
  admin_notes: string | null;
  created_at: string;
  provider?: {
    business_name: string;
    category: string;
  };
  client?: {
    full_name: string;
  };
}
interface SupportMessage {
  id: string;
  user_id: string;
  subject: string;
  message: string;
  priority: "low" | "medium" | "high" | "urgent";
  status: "pending" | "in_progress" | "resolved" | "dismissed";
  admin_response: string | null;
  admin_id: string | null;
  created_at: string;
  updated_at: string;
  user?: {
    id: string;
    full_name: string;
    email: string;
  };
  admin?: {
    id: string;
    full_name: string;
  };
}

function AdminDashboard() {
  const queryClient = useQueryClient();
  const [providers, setProviders] = useState<ProviderRow[]>([]);
  const [stats, setStats] = useState({ users: 0, requests: 0, providers: 0, pendingDocs: 0 });
  const [rejectDialogOpen, setRejectDialogOpen] = useState(false);
  const [rejectingProvider, setRejectingProvider] = useState<ProviderRow | null>(null);
  const [rejectReason, setRejectReason] = useState("");
  const [verifiedRegistrations, setVerifiedRegistrations] = useState<Set<string>>(new Set());
  const [reportDialogOpen, setReportDialogOpen] = useState(false);
  const [selectedReport, setSelectedReport] = useState<ProviderReport | null>(null);
  const [adminNotes, setAdminNotes] = useState("");
  const [reportStatus, setReportStatus] = useState<
    "pending" | "reviewed" | "resolved" | "dismissed"
  >("pending");

  // Support messages state
  const [supportMessages, setSupportMessages] = useState<SupportMessage[]>([]);
  const [supportDialogOpen, setSupportDialogOpen] = useState(false);
  const [selectedSupportMessage, setSelectedSupportMessage] = useState<SupportMessage | null>(null);
  const [supportResponse, setSupportResponse] = useState("");
  const [supportStatus, setSupportStatus] = useState<
    "pending" | "in_progress" | "resolved" | "dismissed"
  >("pending");

  const load = async () => {
    const [{ data: pData }, { count: uc }, { count: rc }, { count: pc }, { count: pdc }] =
      await Promise.all([
        supabase
          .from("service_providers")
          .select("*, documents(*)")
          .order("created_at", { ascending: false }),
        supabase.from("profiles").select("*", { count: "exact", head: true }),
        supabase.from("service_requests").select("*", { count: "exact", head: true }),
        supabase
          .from("service_providers")
          .select("*", { count: "exact", head: true })
          .eq("verification_status", "verified"),
        supabase
          .from("documents")
          .select("*", { count: "exact", head: true })
          .eq("status", "pending"),
      ]);

    // Fetch reports for each provider
    const providersWithReports = await Promise.all(
      (pData ?? []).map(async (provider: ProviderRow) => {
        const { data: reports } = await supabase
          .from("provider_reports")
          .select("*")
          .eq("provider_id", provider.id);
        return { ...provider, reports: reports || [] };
      }),
    );

    setProviders(providersWithReports as ProviderRow[]);
    setStats({ users: uc ?? 0, requests: rc ?? 0, providers: pc ?? 0, pendingDocs: pdc ?? 0 });

    // Fetch support messages
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (session) {
      const supportData = await getSupportMessages({
        headers: { Authorization: `Bearer ${session.access_token}` },
      });
      setSupportMessages(supportData);
    }
  };
  useEffect(() => {
    load();
  }, []);

  // Real-time subscriptions for admin dashboard
  useRealtimeSubscription({
    table: "service_providers",
    onUpdate: () => {
      load();
    },
  });

  useRealtimeSubscription({
    table: "documents",
    onInsert: () => {
      load();
    },
    onUpdate: () => {
      load();
    },
  });

  useRealtimeSubscription({
    table: "provider_reports",
    onInsert: () => {
      refetchReports();
    },
    onUpdate: () => {
      refetchReports();
    },
  });

  useRealtimeSubscription({
    table: "support_messages",
    onInsert: () => {
      load();
    },
    onUpdate: () => {
      load();
    },
  });

  // Fetch provider reports
  const {
    data: reports = [],
    isLoading: reportsLoading,
    refetch: refetchReports,
  } = useQuery({
    queryKey: ["providerReports"],
    queryFn: async () => {
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await getProviderReports({
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res as ProviderReport[];
    },
  });

  // Update report mutation
  const updateReportMutation = useMutation({
    mutationFn: async () => {
      if (!selectedReport) throw new Error("No report selected");
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await updateProviderReport({
        data: {
          report_id: selectedReport.id,
          status: reportStatus,
          admin_notes: adminNotes || undefined,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Report updated successfully");
      setReportDialogOpen(false);
      setSelectedReport(null);
      setAdminNotes("");
      setReportStatus("pending");
      refetchReports();
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to update report");
    },
  });

  // Respond to support message mutation
  const respondSupportMutation = useMutation({
    mutationFn: async () => {
      if (!selectedSupportMessage) throw new Error("No support message selected");
      const { data: sessionData } = await supabase.auth.getSession();
      const session = sessionData?.session;
      const res = await respondToSupportMessage({
        data: {
          id: selectedSupportMessage.id,
          response: supportResponse,
          status: supportStatus,
        },
        headers: { Authorization: `Bearer ${session?.access_token}` },
      });
      return res;
    },
    onSuccess: () => {
      toast.success("Response sent successfully");
      setSupportDialogOpen(false);
      setSelectedSupportMessage(null);
      setSupportResponse("");
      setSupportStatus("pending");
      load();
    },
    onError: (err) => {
      toast.error(err instanceof Error ? err.message : "Failed to send response");
    },
  });

  const setProviderStatus = async (
    id: string,
    verification_status: "verified" | "rejected",
    reason?: string,
  ) => {
    const updateData: {
      verification_status: string;
      review_notes?: string;
    } = { verification_status };
    if (reason && verification_status === "rejected") {
      updateData.review_notes = reason;
    }

    const { error } = await supabase.from("service_providers").update(updateData).eq("id", id);
    if (error) toast.error(error.message);
    else {
      toast.success(`Provider ${verification_status}`);
      load();
    }
  };

  const handleReject = async () => {
    if (!rejectingProvider) return;
    await setProviderStatus(rejectingProvider.id, "rejected", rejectReason);
    setRejectDialogOpen(false);
    setRejectReason("");
    setRejectingProvider(null);
  };

  const openRejectDialog = (provider: ProviderRow) => {
    setRejectingProvider(provider);
    setRejectDialogOpen(true);
  };

  const setDocStatus = async (id: string, status: "approved" | "rejected") => {
    const { error } = await supabase.from("documents").update({ status }).eq("id", id);
    if (error) toast.error(error.message);
    else {
      toast.success(`Document ${status}`);
      load();
    }
  };

  const viewDoc = async (path: string) => {
    const { data, error } = await supabase.storage
      .from("provider-documents")
      .createSignedUrl(path, 60);
    if (error || !data) {
      toast.error("Could not open document");
      return;
    }
    window.open(data.signedUrl, "_blank");
  };

  const verifyBusinessRegistration = async (registrationNumber: string, businessName: string) => {
    if (!registrationNumber || !businessName) {
      toast.error("Business registration number and business name are required");
      return false;
    }

    try {
      // Use raw SQL query with lowercase conversion at runtime
      const { data, error } = await from("business_registrations")
        .select("*")
        .filter("registration_number", "ilike", registrationNumber)
        .filter("business_name", "ilike", businessName)
        .eq("status", "active")
        .maybeSingle();

      if (error) {
        toast.error("Failed to verify business registration");
        console.error("Verification error:", error);
        return false;
      }

      if (data) {
        toast.success("Business registration verified");
        setVerifiedRegistrations((prev) => new Set(prev).add(registrationNumber));
        return true;
      } else {
        toast.error("Business registration not found in database");
        return false;
      }
    } catch (error) {
      toast.error(
        "External registration database not configured. Please check environment variables.",
      );
      console.error("Registration database error:", error);
      return false;
    }
  };

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />
      <main className="flex-1 bg-white">
        <div className="mx-auto max-w-6xl px-4 py-10">
          <h1 className="text-3xl font-bold tracking-tight">Admin dashboard</h1>
          <p className="mt-1 text-muted-foreground">
            Approve providers, review documents, monitor activity.
          </p>

          <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <StatCard label="Users" value={stats.users} />
            <StatCard label="Requests" value={stats.requests} />
            <StatCard label="Verified providers" value={stats.providers} />
            <StatCard label="Docs pending" value={stats.pendingDocs} />
            <StatCard label="Provider reports" value={reports.length} />
          </div>

          <section className="mt-10">
            <h2 className="mb-3 text-xl font-semibold">All providers</h2>
            {providers.length === 0 ? (
              <Card className="p-6 text-center text-sm text-muted-foreground">
                No providers yet.
              </Card>
            ) : (
              <div className="space-y-3">
                {providers.map((p) => (
                  <Card key={p.id} className="p-4">
                    <div className="flex flex-wrap items-start justify-between gap-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <p className="font-medium">{p.business_name}</p>
                          <Badge variant="secondary">{p.category}</Badge>
                          <Badge
                            variant={
                              p.verification_status === "verified"
                                ? "default"
                                : p.verification_status === "rejected"
                                  ? "destructive"
                                  : "secondary"
                            }
                          >
                            {p.verification_status}
                          </Badge>
                          {p.reports && p.reports.length > 0 && (
                            <Badge variant="destructive">
                              {p.reports.length} Report{p.reports.length > 1 ? "s" : ""}
                            </Badge>
                          )}
                        </div>
                        {p.location && (
                          <p className="text-xs text-muted-foreground mt-1">{p.location}</p>
                        )}
                        {p.business_registration_number && (
                          <p className="text-xs text-muted-foreground mt-1">
                            Registration: {p.business_registration_number}
                          </p>
                        )}

                        {/* Show reports for this provider */}
                        {p.reports && p.reports.length > 0 && (
                          <div className="mt-3 space-y-2">
                            <p className="text-xs font-medium text-muted-foreground">
                              Reports ({p.reports.length}):
                            </p>
                            <div className="space-y-1">
                              {p.reports.map((report: ProviderReport) => (
                                <div
                                  key={report.id}
                                  className="flex items-start justify-between rounded border border-red-200 bg-red-50 p-2"
                                >
                                  <div className="flex-1">
                                    <p className="text-xs font-medium text-red-800">
                                      Status: {report.status}
                                    </p>
                                    <p className="text-xs text-red-700 mt-1">
                                      {report.report_text}
                                    </p>
                                    {report.admin_notes && (
                                      <p className="text-xs text-muted-foreground mt-1">
                                        Admin notes: {report.admin_notes}
                                      </p>
                                    )}
                                    <p className="text-xs text-muted-foreground mt-1">
                                      {new Date(report.created_at).toLocaleDateString()}
                                    </p>
                                  </div>
                                </div>
                              ))}
                            </div>
                          </div>
                        )}

                        {/* Show documents for this provider */}
                        {p.documents && p.documents.length > 0 && (
                          <div className="mt-3 space-y-2">
                            <p className="text-xs font-medium text-muted-foreground">Documents:</p>
                            <div className="space-y-1">
                              {p.documents.map((doc) => (
                                <div
                                  key={doc.id}
                                  className="flex items-center justify-between rounded border border-border bg-background/50 p-2"
                                >
                                  <div className="flex items-center gap-2">
                                    <span className="text-xs">{doc.file_name}</span>
                                    {/* Only show status for rejected or pending documents */}
                                    {(doc.status === "rejected" || doc.status === "pending") && (
                                      <Badge
                                        variant={
                                          doc.status === "rejected" ? "destructive" : "secondary"
                                        }
                                        className="text-xs"
                                      >
                                        {doc.status}
                                      </Badge>
                                    )}
                                  </div>
                                  <div className="flex gap-1">
                                    <Button
                                      size="sm"
                                      variant="ghost"
                                      className="h-6 text-xs"
                                      onClick={() => viewDoc(doc.file_path)}
                                    >
                                      View
                                    </Button>
                                    {doc.status === "pending" && (
                                      <>
                                        <Button
                                          size="sm"
                                          variant="ghost"
                                          className="h-6 text-xs text-green-600"
                                          onClick={() => setDocStatus(doc.id, "approved")}
                                        >
                                          Approve
                                        </Button>
                                        <Button
                                          size="sm"
                                          variant="ghost"
                                          className="h-6 text-xs text-red-600"
                                          onClick={() => setDocStatus(doc.id, "rejected")}
                                        >
                                          Reject
                                        </Button>
                                      </>
                                    )}
                                  </div>
                                </div>
                              ))}
                            </div>
                          </div>
                        )}
                      </div>
                      <div className="flex gap-2">
                        {p.business_registration_number && (
                          <Button
                            size="sm"
                            variant={
                              verifiedRegistrations.has(p.business_registration_number)
                                ? "default"
                                : "outline"
                            }
                            onClick={() =>
                              verifyBusinessRegistration(
                                p.business_registration_number!,
                                p.business_name!,
                              )
                            }
                            disabled={verifiedRegistrations.has(p.business_registration_number)}
                          >
                            {verifiedRegistrations.has(p.business_registration_number)
                              ? "Verified Registration"
                              : "Verify Registration"}
                          </Button>
                        )}
                        {p.verification_status !== "verified" && (
                          <Button
                            size="sm"
                            className="bg-success text-success-foreground hover:opacity-90"
                            onClick={() => setProviderStatus(p.id, "verified")}
                          >
                            Verify
                          </Button>
                        )}
                        {p.verification_status !== "rejected" && (
                          <Button
                            size="sm"
                            variant="destructive"
                            onClick={() => openRejectDialog(p)}
                          >
                            Reject
                          </Button>
                        )}
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            )}
          </section>

          {/* Provider Reports Section */}
          <section className="mt-10">
            <h2 className="mb-3 text-xl font-semibold">Provider Reports</h2>
            {reportsLoading ? (
              <div className="flex items-center gap-2 text-sm text-muted-foreground">Loading…</div>
            ) : reports.length === 0 ? (
              <Card className="p-6 text-center text-sm text-muted-foreground">
                No provider reports yet.
              </Card>
            ) : (
              <div className="space-y-3">
                {reports.map((report) => (
                  <Card key={report.id} className="p-4">
                    <div className="flex flex-wrap items-start justify-between gap-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <p className="font-medium">
                            {report.provider?.business_name || "Unknown Provider"}
                          </p>
                          <Badge variant="secondary">
                            {report.provider?.category || "Unknown"}
                          </Badge>
                          <Badge
                            variant={
                              report.status === "pending"
                                ? "secondary"
                                : report.status === "reviewed"
                                  ? "default"
                                  : report.status === "resolved"
                                    ? "default"
                                    : "destructive"
                            }
                          >
                            {report.status}
                          </Badge>
                        </div>
                        <p className="mt-2 text-sm text-muted-foreground">
                          Reported by: {report.client?.full_name || "Unknown"}
                        </p>
                        <p className="mt-1 text-sm text-muted-foreground">
                          Reason: {report.report_text}
                        </p>
                        {report.match?.service_request?.request_text && (
                          <p className="mt-1 text-xs text-muted-foreground">
                            Original request:{" "}
                            {report.match.service_request.request_text.substring(0, 100)}...
                          </p>
                        )}
                        {report.admin_notes && (
                          <p className="mt-2 text-sm text-muted-foreground">
                            <span className="font-medium">Admin notes:</span> {report.admin_notes}
                          </p>
                        )}
                        <p className="mt-2 text-xs text-muted-foreground">
                          {new Date(report.created_at).toLocaleDateString()}
                        </p>
                      </div>
                      <div className="flex gap-2">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => {
                            setSelectedReport(report);
                            setAdminNotes(report.admin_notes || "");
                            setReportStatus(report.status);
                            setReportDialogOpen(true);
                          }}
                        >
                          Review
                        </Button>
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            )}
          </section>

          {/* Support Messages Section */}
          <section className="mt-10">
            <h2 className="mb-3 text-xl font-semibold">Support Messages</h2>
            {supportMessages.length === 0 ? (
              <Card className="p-6 text-center text-sm text-muted-foreground">
                No support messages yet.
              </Card>
            ) : (
              <div className="space-y-3">
                {supportMessages.map((msg) => (
                  <Card key={msg.id} className="p-4 shadow-card border-2">
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2">
                          <p className="font-semibold">{msg.subject}</p>
                          <Badge
                            variant={
                              msg.priority === "urgent"
                                ? "destructive"
                                : msg.priority === "high"
                                  ? "default"
                                  : msg.priority === "medium"
                                    ? "secondary"
                                    : "outline"
                            }
                          >
                            {msg.priority}
                          </Badge>
                          <Badge
                            variant={
                              msg.status === "resolved"
                                ? "default"
                                : msg.status === "in_progress"
                                  ? "secondary"
                                  : msg.status === "dismissed"
                                    ? "outline"
                                    : "destructive"
                            }
                          >
                            {msg.status}
                          </Badge>
                        </div>
                        <p className="text-sm text-muted-foreground mb-2">
                          From: {msg.user?.full_name || "Unknown"} (
                          {msg.user?.email || "No email"})
                        </p>
                        <p className="text-sm">{msg.message}</p>
                        <p className="text-xs text-muted-foreground mt-2">
                          {new Date(msg.created_at).toLocaleString()}
                        </p>
                        {msg.admin_response && (
                          <div className="mt-3 p-3 bg-primary/5 rounded border border-primary/20">
                            <p className="text-xs font-medium mb-1">Admin Response:</p>
                            <p className="text-sm">{msg.admin_response}</p>
                          </div>
                        )}
                      </div>
                      <div className="flex gap-2">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => {
                            setSelectedSupportMessage(msg);
                            setSupportResponse(msg.admin_response || "");
                            setSupportStatus(msg.status);
                            setSupportDialogOpen(true);
                          }}
                        >
                          Respond
                        </Button>
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            )}
          </section>
        </div>
      </main>

      {/* Reject Provider Dialog */}
      <Dialog open={rejectDialogOpen} onOpenChange={setRejectDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Reject Provider Profile</DialogTitle>
            <DialogDescription>
              Please provide a reason for rejecting this provider profile. This will help the
              provider understand what needs to be improved.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <p className="text-sm text-muted-foreground">
                Provider: <span className="font-medium">{rejectingProvider?.business_name}</span>
              </p>
            </div>
            <div className="space-y-2">
              <Label htmlFor="reject-reason">Reason for rejection</Label>
              <Textarea
                id="reject-reason"
                placeholder="Please provide a reason for rejecting this provider profile..."
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
                rows={4}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setRejectDialogOpen(false)}>
              Cancel
            </Button>
            <Button variant="destructive" onClick={handleReject} disabled={!rejectReason.trim()}>
              Reject Profile
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Review Report Dialog */}
      <Dialog open={reportDialogOpen} onOpenChange={setReportDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Review Provider Report</DialogTitle>
            <DialogDescription>
              Review and update the status of this provider report.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <p className="text-sm text-muted-foreground">
                Provider:{" "}
                <span className="font-medium">
                  {selectedReport?.provider?.business_name || "Unknown"}
                </span>
              </p>
              <p className="text-sm text-muted-foreground">
                Reported by:{" "}
                <span className="font-medium">
                  {selectedReport?.client?.full_name || "Unknown"}
                </span>
              </p>
              <p className="mt-2 text-sm text-muted-foreground">
                Report: {selectedReport?.report_text}
              </p>
            </div>
            <div className="space-y-2">
              <Label htmlFor="report-status">Status</Label>
              <select
                id="report-status"
                value={reportStatus}
                onChange={(e) =>
                  setReportStatus(
                    e.target.value as "pending" | "reviewed" | "resolved" | "dismissed",
                  )
                }
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="pending">Pending</option>
                <option value="reviewed">Reviewed</option>
                <option value="resolved">Resolved</option>
                <option value="dismissed">Dismissed</option>
              </select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="admin-notes">Admin notes</Label>
              <Textarea
                id="admin-notes"
                placeholder="Add notes about this report..."
                value={adminNotes}
                onChange={(e) => setAdminNotes(e.target.value)}
                rows={3}
              />
            </div>
          </div>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setReportDialogOpen(false);
                setSelectedReport(null);
                setAdminNotes("");
                setReportStatus("pending");
              }}
            >
              Cancel
            </Button>
            <Button
              onClick={() => updateReportMutation.mutate()}
              disabled={updateReportMutation.isPending}
            >
              {updateReportMutation.isPending ? "Updating..." : "Update Report"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Support Message Dialog */}
      <Dialog open={supportDialogOpen} onOpenChange={setSupportDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Respond to Support Message</DialogTitle>
            <DialogDescription>
              Respond to this support request and update its status.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div>
              <p className="text-sm text-muted-foreground">
                From:{" "}
                <span className="font-medium">
                  {selectedSupportMessage?.user?.full_name || "Unknown"}
                </span>
              </p>
              <p className="text-sm text-muted-foreground">
                Subject: <span className="font-medium">{selectedSupportMessage?.subject}</span>
              </p>
              <p className="mt-2 text-sm text-muted-foreground">
                Message: {selectedSupportMessage?.message}
              </p>
              <p className="text-xs text-muted-foreground mt-1">
                Priority: {selectedSupportMessage?.priority}
              </p>
            </div>
            <div className="space-y-2">
              <Label htmlFor="support-status">Status</Label>
              <select
                id="support-status"
                value={supportStatus}
                onChange={(e) =>
                  setSupportStatus(
                    e.target.value as "pending" | "in_progress" | "resolved" | "dismissed",
                  )
                }
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="pending">Pending</option>
                <option value="in_progress">In Progress</option>
                <option value="resolved">Resolved</option>
                <option value="dismissed">Dismissed</option>
              </select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="support-response">Your Response</Label>
              <Textarea
                id="support-response"
                placeholder="Type your response to the user..."
                value={supportResponse}
                onChange={(e) => setSupportResponse(e.target.value)}
                rows={4}
              />
            </div>
          </div>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setSupportDialogOpen(false);
                setSelectedSupportMessage(null);
                setSupportResponse("");
                setSupportStatus("pending");
              }}
            >
              Cancel
            </Button>
            <Button
              onClick={() => respondSupportMutation.mutate()}
              disabled={respondSupportMutation.isPending}
            >
              {respondSupportMutation.isPending ? "Sending..." : "Send Response"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function StatCard({ label, value }: { label: string; value: number }) {
  return (
    <Card className="p-5 shadow-card">
      <div className="flex items-center gap-3">
        <div>
          <p className="text-xs text-muted-foreground">{label}</p>
          <p className="text-2xl font-bold tracking-tight">{value}</p>
        </div>
      </div>
    </Card>
  );
}
