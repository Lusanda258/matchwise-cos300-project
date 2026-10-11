import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { match_id, client_id, provider_id } = await req.json()

    if (!match_id || !client_id || !provider_id) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Initialize Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Get match details
    const { data: match, error: matchError } = await supabase
      .from('matches')
      .select(`
        *,
        provider:service_providers(business_name, category)
      `)
      .eq('id', match_id)
      .single()

    if (matchError || !match) {
      console.error('Match not found:', matchError)
      return new Response(
        JSON.stringify({ error: 'Match not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get client's email
    const { data: client } = await supabase
      .from('profiles')
      .select('email, full_name')
      .eq('id', client_id)
      .single()

    if (!client || !client.email) {
      console.error('Client not found or no email')
      return new Response(
        JSON.stringify({ error: 'Client not found or no email' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Generate email HTML
    const html = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Request Accepted on MatchWise</title>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
          .container { background: #f9f9f9; border-radius: 8px; padding: 30px; }
          .header { background: #000; color: white; padding: 20px; border-radius: 8px 8px 0 0; margin: -30px -30px 30px -30px; }
          .header h1 { margin: 0; font-size: 24px; }
          .success-box { background: #d4edda; padding: 20px; border-left: 4px solid #28a745; margin: 20px 0; }
          .button { display: inline-block; background: #000; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 20px; }
          .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; font-size: 12px; color: #666; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>MatchWise</h1>
          </div>
          
          <h2>Request Accepted! 🎉</h2>
          
          <p>Hi ${client.full_name || 'there'},</p>
          
          <div class="success-box">
            <p><strong>Great news!</strong> Your service request has been accepted by <strong>${match.provider?.business_name || 'A provider'}</strong> (${match.provider?.category || 'Service'}).</p>
          </div>
          
          <p>You can now start communicating with the provider through the chat system to discuss details and arrange the service.</p>
          
          <a href="${Deno.env.get('APP_URL') || 'http://localhost:5173'}/chat/${match_id}" class="button">Start Chat</a>
          
          <div class="footer">
            <p>This is an automated notification from MatchWise. Please do not reply to this email.</p>
          </div>
        </div>
      </body>
      </html>
    `

    // Call send-email function
    const { error: emailError } = await supabase.functions.invoke('send-email', {
      body: {
        to: client.email,
        subject: `Your request has been accepted on MatchWise!`,
        html: html,
      },
    })

    if (emailError) {
      console.error('Error sending email:', emailError)
      return new Response(
        JSON.stringify({ error: emailError.message }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in request accepted notification:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
