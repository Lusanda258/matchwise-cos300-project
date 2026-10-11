-- Create table to track failed login attempts
CREATE TABLE IF NOT EXISTS failed_login_attempts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  attempt_count INTEGER DEFAULT 1,
  last_attempt_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  locked_until TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_failed_login_attempts_email ON failed_login_attempts(email);

-- Create index on locked_until for finding active lockouts
CREATE INDEX IF NOT EXISTS idx_failed_login_attempts_locked_until ON failed_login_attempts(locked_until);

-- DISABLE RLS for this table to allow service role access
ALTER TABLE failed_login_attempts DISABLE ROW LEVEL SECURITY;

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists, then recreate
DROP TRIGGER IF EXISTS update_failed_login_attempts_updated_at ON failed_login_attempts;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_failed_login_attempts_updated_at
  BEFORE UPDATE ON failed_login_attempts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
