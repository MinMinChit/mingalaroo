-- Create invited_users table
CREATE TABLE IF NOT EXISTS invited_users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  guest_name TEXT NOT NULL,
  generated_link TEXT NOT NULL UNIQUE,
  attendance_state TEXT NOT NULL DEFAULT 'pending' CHECK (attendance_state IN ('pending', 'attending', 'not_attending')),
  guest_count TEXT NOT NULL DEFAULT '-',
  gift_status TEXT NOT NULL DEFAULT 'not_yet' CHECK (gift_status IN ('not_yet', 'gifted')),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_invited_users_user_id ON invited_users(user_id);

-- Create index on generated_link for faster lookups
CREATE INDEX IF NOT EXISTS idx_invited_users_generated_link ON invited_users(generated_link);

-- Enable Row Level Security
ALTER TABLE invited_users ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see their own guests
CREATE POLICY "Users can view their own guests"
  ON invited_users
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy: Users can insert their own guests
CREATE POLICY "Users can insert their own guests"
  ON invited_users
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can update their own guests
CREATE POLICY "Users can update their own guests"
  ON invited_users
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can delete their own guests
CREATE POLICY "Users can delete their own guests"
  ON invited_users
  FOR DELETE
  USING (auth.uid() = user_id);

-- Public policies for guest RSVP updates
-- Allow public users to view their invitation by generated_link
CREATE POLICY "Public can view invitation by link"
  ON invited_users
  FOR SELECT
  TO public
  USING (true);

-- Allow public users to update records
-- Note: Field restrictions are enforced by trigger below
CREATE POLICY "Public can update RSVP fields"
  ON invited_users
  FOR UPDATE
  TO public
  USING (true)
  WITH CHECK (true);

-- Create trigger function to prevent updates to protected fields
-- Admins (authenticated users) can update any field
-- Public users can only update: attendance_state, guest_count, gift_status
CREATE OR REPLACE FUNCTION prevent_protected_field_updates()
RETURNS TRIGGER AS $$
BEGIN
  -- If user is authenticated (admin), allow all updates
  IF auth.uid() IS NOT NULL THEN
    RETURN NEW;
  END IF;
  
  -- For public (unauthenticated) users, prevent changes to protected fields
  IF OLD.guest_name IS DISTINCT FROM NEW.guest_name THEN
    RAISE EXCEPTION 'Cannot update guest_name field';
  END IF;
  
  IF OLD.generated_link IS DISTINCT FROM NEW.generated_link THEN
    RAISE EXCEPTION 'Cannot update generated_link field';
  END IF;
  
  IF OLD.user_id IS DISTINCT FROM NEW.user_id THEN
    RAISE EXCEPTION 'Cannot update user_id field';
  END IF;
  
  IF OLD.id IS DISTINCT FROM NEW.id THEN
    RAISE EXCEPTION 'Cannot update id field';
  END IF;
  
  IF OLD.created_at IS DISTINCT FROM NEW.created_at THEN
    RAISE EXCEPTION 'Cannot update created_at field';
  END IF;
  
  -- Public users can only update: attendance_state, guest_count, gift_status
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to enforce field restrictions
CREATE TRIGGER prevent_protected_field_updates_trigger
  BEFORE UPDATE ON invited_users
  FOR EACH ROW
  EXECUTE FUNCTION prevent_protected_field_updates();

