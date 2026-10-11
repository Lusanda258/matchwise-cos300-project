import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/integrations/supabase/client.server";

const ReportSchema = z.object({
  match_id: z.string().min(1),
  report_text: z.string().min(10).max(1000),
});

interface ReportResult {
  id: string;
  match_id: string;
  provider_id: string;
  client_id: string;
  report_text: string;
  status: string;
  created_at: string;
}

// Create a provider report
export const createProviderReport = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => ReportSchema.parse(input))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    console.log("Creating report for match_id:", data.match_id);

    // Verify the match exists
    const { data: match, error: matchError } = await supabaseAdmin
      .from("matches")
      .select(`
        id,
        provider_id,
        request_id
      `)
      .eq("id", data.match_id)
      .single();

    console.log("Match lookup result:", { match, matchError });

    if (matchError || !match) {
      console.error("Match not found error:", matchError);
      throw new Error("Match not found");
    }

    // Verify the user is the client for this match by checking the service_request
    const { data: serviceRequest, error: requestError } = await supabaseAdmin
      .from("service_requests")
      .select("client_id, status")
      .eq("id", match.request_id)
      .single();

    console.log("Service request lookup result:", { serviceRequest, requestError });

    if (requestError || !serviceRequest) {
      console.error("Service request not found error:", requestError);
      throw new Error("Service request not found");
    }

    if (serviceRequest.client_id !== userId) {
      console.log("Client ownership check failed:", { 
        client_id: serviceRequest.client_id, 
        userId 
      });
      throw new Error("You can only report providers for your own matches");
    }

    // Verify the service request is in "in_progress" status
    if (serviceRequest.status !== "in_progress") {
      console.log("Service request status check failed:", { status: serviceRequest.status });
      throw new Error("You can only report providers when the service request is in progress");
    }

    // Check if a report already exists for this match using admin client
    const { data: existingReport } = await supabaseAdmin
      .from("provider_reports")
      .select("id")
      .eq("match_id", data.match_id)
      .eq("client_id", userId)
      .maybeSingle();

    if (existingReport) {
      throw new Error("You have already reported this provider for this match");
    }

    // Create the report using admin client to bypass RLS
    const { data: report, error: reportError } = await supabaseAdmin
      .from("provider_reports")
      .insert({
        match_id: data.match_id,
        provider_id: match.provider_id,
        client_id: userId,
        report_text: data.report_text,
        status: "pending",
      })
      .select()
      .single();

    if (reportError) {
      console.error("Report creation error:", reportError);
      throw new Error(reportError.message ?? "Failed to create report");
    }
    if (!report) {
      throw new Error("Failed to create report - no data returned");
    }

    return report as ReportResult;
  });

// Get all reports (admin only)
export const getProviderReports = createServerFn({ method: "GET" })
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
      throw new Error("Only admins can view reports");
    }

    // Get all reports with related data using admin client to bypass RLS
    const { data: reports, error } = await supabaseAdmin
      .from("provider_reports")
      .select(`
        *,
        provider:service_providers(business_name, category),
        client:profiles(full_name),
        match:matches(
          service_request:service_requests(request_text)
        )
      `)
      .order("created_at", { ascending: false });

    if (error) {
      throw new Error(error.message);
    }

    return reports ?? [];
  });

// Update report status (admin only)
const UpdateReportSchema = z.object({
  report_id: z.string().min(1),
  status: z.enum(["pending", "reviewed", "resolved", "dismissed"]),
  admin_notes: z.string().optional(),
});

export const updateProviderReport = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => UpdateReportSchema.parse(input))
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
      throw new Error("Only admins can update reports");
    }

    // Update the report using admin client to bypass RLS
    const updateData: any = {
      status: data.status,
    };

    if (data.admin_notes !== undefined) {
      updateData.admin_notes = data.admin_notes;
    }

    const { data: report, error } = await supabaseAdmin
      .from("provider_reports")
      .update(updateData)
      .eq("id", data.report_id)
      .select()
      .single();

    if (error || !report) {
      throw new Error(error?.message ?? "Failed to update report");
    }

    return report;
  });

// Get reports for current user (client)
export const getClientReports = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: reports, error } = await supabaseAdmin
      .from("provider_reports")
      .select(`
        *,
        provider:service_providers(business_name, category),
        match:matches(
          service_request:service_requests(request_text)
        )
      `)
      .eq("client_id", userId)
      .order("created_at", { ascending: false });

    if (error) {
      throw new Error(error.message);
    }

    return reports ?? [];
  });