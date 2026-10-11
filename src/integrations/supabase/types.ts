export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      ratings: {
        Row: {
          client_id: string
          comment: string | null
          created_at: string
          id: string
          provider_id: string
          rating: number
        }
        Insert: {
          client_id: string
          comment?: string | null
          created_at?: string
          id?: string
          provider_id: string
          rating: number
        }
        Update: {
          client_id?: string
          comment?: string | null
          created_at?: string
          id?: string
          provider_id?: string
          rating?: number
        }
      }
      matches: {
        Row: {
          created_at: string
          id: string
          inquiry_message: string | null
          inquiry_preferred_date: string | null
          inquiry_requested_at: string | null
          inquiry_status: string
          provider_id: string
          reason: string | null
          request_id: string
          score: number
          status: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          inquiry_message?: string | null
          inquiry_preferred_date?: string | null
          inquiry_requested_at?: string | null
          inquiry_status?: string
          provider_id: string
          reason?: string | null
          request_id: string
          score: number
          status?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          inquiry_message?: string | null
          inquiry_preferred_date?: string | null
          inquiry_requested_at?: string | null
          inquiry_status?: string
          provider_id?: string
          reason?: string | null
          request_id?: string
          score?: number
          status?: string | null
        }
      }
      // Add other table types as needed...
    }
  }
}

export type Tables<
  TableName extends keyof Database["public"]["Tables"]
> = Database["public"]["Tables"][TableName]["Row"]

export type TablesInsert<
  TableName extends keyof Database["public"]["Tables"]
> = Database["public"]["Tables"][TableName]["Insert"]

export type TablesUpdate<
  TableName extends keyof Database["public"]["Tables"]
> = Database["public"]["Tables"][TableName]["Update"]
