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
    const { match_id, sender_id, message } = await req.json()

    if (!match_id || !sender_id || !message) {
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
        service_request:service_requests(client_id),
        provider:service_providers(user_id)
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

    // Determine recipient
    const clientId = match.service_request?.client_id
    const providerUserId = match.provider?.user_id

    if (!clientId || !providerUserId) {
      return new Response(
        JSON.stringify({ error: 'Match data incomplete' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const recipientId = sender_id === clientId ? providerUserId : clientId

    // Get recipient's email and name
    const { data: recipient } = await supabase
      .from('profiles')
      .select('email, full_name')
      .eq('id', recipientId)
      .single()

    if (!recipient || !recipient.email) {
      console.error('Recipient not found or no email')
      return new Response(
        JSON.stringify({ error: 'Recipient not found or no email' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get sender's name
    const { data: sender } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', sender_id)
      .single()

    if (!sender) {
      return new Response(
        JSON.stringify({ error: 'Sender not found' }),
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
        <title>New Message on MatchWise</title>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
          .container { background: #f9f9f9; border-radius: 8px; padding: 30px; }
          .header { background: #000; color: white; padding: 20px; border-radius: 8px 8px 0 0; margin: -30px -30px 30px -30px; }
          .header h1 { margin: 0; font-size: 24px; }
          .message-box { background: white; padding: 20px; border-left: 4px solid #000; margin: 20px 0; }
          .button { display: inline-block; background: #000; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin-top: 20px; }
          .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; font-size: 12px; color: #666; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>MatchWise</h1>
          </div>
          
          <h2>New Message Received</h2>
          
          <p>Hi ${recipient.full_name || 'there'},</p>
          
          <p>You have received a new message from <strong>${sender.full_name || 'Someone'}</strong>:</p>
          
          <div class="message-box">
            <p>"${message}"</p>
          </div>
          
          <p>Click the button below to view and reply to the message:</p>
          
          <a href="${Deno.env.get('APP_URL') || 'http://localhost:5173'}/chat/${match_id}" class="button">View Chat</a>
          
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
        to: recipient.email,
        subject: `New message from ${sender.full_name || 'Someone'} on MatchWise`,
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
    console.error('Error in chat notification:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
