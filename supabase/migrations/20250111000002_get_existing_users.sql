-- Run this query to get existing user IDs from your database
-- Copy the IDs and replace the placeholder IDs in the testing providers migration

SELECT id, email, created_at
FROM public.users
ORDER BY created_at DESC
LIMIT 30;
