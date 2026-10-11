import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

interface EmailQueueItem {
  id: string
  user_id: string
  email: string | null
  notification_id: string
  title: string
  message: string
  status: string
}

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
    // Initialize Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const sendgridApiKey = Deno.env.get('SENDGRID_API_KEY')
    
    console.log('Environment check:', {
      hasSupabaseUrl: !!supabaseUrl,
      hasSupabaseServiceKey: !!supabaseServiceKey,
      hasSendgridApiKey: !!sendgridApiKey,
      sendgridApiKeyPrefix: sendgridApiKey ? sendgridApiKey.substring(0, 10) + '...' : 'none'
    })
    
    if (!sendgridApiKey) {
      console.error('Missing SENDGRID_API_KEY environment variable')
      return new Response(JSON.stringify({ error: 'Email service not configured' }), { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Fetch pending emails from queue
    const { data: pendingEmails, error: fetchError } = await supabase
      .from('email_queue')
      .select('*')
      .eq('status', 'pending')
      .limit(10)

    if (fetchError) {
      console.error('Error fetching email queue:', fetchError)
      return new Response(JSON.stringify({ error: 'Failed to fetch email queue' }), { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    if (!pendingEmails || pendingEmails.length === 0) {
      return new Response(JSON.stringify({ message: 'No pending emails' }), {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    // Process each email
    const results = await Promise.allSettled(
      pendingEmails.map(async (emailItem: EmailQueueItem) => {
        if (!emailItem.email) {
          // Skip if no email address
          await supabase
            .from('email_queue')
            .update({ status: 'failed', error_message: 'No email address' })
            .eq('id', emailItem.id)
          return { success: false, error: 'No email address' }
        }

        try {
          // Send email via SendGrid API
          console.log('Sending email to:', emailItem.email)
          
          const emailPayload = {
            personalizations: [{
              to: [{ email: emailItem.email }],
              subject: `New Notification - MatchWise: ${emailItem.title}`
            }],
            from: {
              email: 'group14cos300@gmail.com',
              name: 'MatchWise'
            },
            content: [{
              type: 'text/html',
              value: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                  <h2 style="color: #333;">New Notification</h2>
                  <p>Hello,</p>
                  <p>You have a new notification on MatchWise:</p>
                  <div style="background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 15px 0;">
                    <h3 style="margin: 0 0 10px 0; color: #000;">${emailItem.title}</h3>
                    <p style="margin: 0; color: #666;">${emailItem.message}</p>
                  </div>
                  <p>Visit your dashboard to view all notifications.</p>
                  <p style="color: #999; font-size: 12px; margin-top: 30px;">
                    This is an automated message from MatchWise.
                  </p>
                </div>
              `
            }]
          }
          
          console.log('Email payload:', JSON.stringify(emailPayload, null, 2))
          
          const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${sendgridApiKey}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(emailPayload),
          })

          if (!response.ok) {
            const errorText = await response.text()
            console.error('SendGrid API error response:', errorText)
            console.error('Response status:', response.status)
            throw new Error(`SendGrid API error: ${errorText}`)
          }

          console.log('Email sent successfully to:', emailItem.email)

          // Mark as sent
          await supabase
            .from('email_queue')
            .update({ status: 'sent', sent_at: new Date().toISOString() })
            .eq('id', emailItem.id)

          return { success: true }
        } catch (error) {
          const errorMessage = error instanceof Error ? error.message : 'Unknown error'
          console.error('Error sending email:', errorMessage)
          console.error('Full error:', error)
          
          // Mark as failed
          await supabase
            .from('email_queue')
            .update({ 
              status: 'failed', 
              error_message: errorMessage 
            })
            .eq('id', emailItem.id)

          return { success: false, error: errorMessage }
        }
      })
    )

    const successful = results.filter(r => r.status === 'fulfilled' && r.value.success).length
    const failed = results.filter(r => r.status === 'rejected' || (r.status === 'fulfilled' && !r.value.success)).length

    return new Response(JSON.stringify({
      message: 'Email queue processed',
      total: pendingEmails.length,
      successful,
      failed
    }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })

  } catch (error) {
    console.error('Error processing email queue:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }
})
