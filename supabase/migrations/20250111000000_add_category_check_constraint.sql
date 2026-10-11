-- Update existing provider categories to match the predefined list
-- Trim whitespace
UPDATE public.service_providers
SET category = TRIM(category)
WHERE category != TRIM(category);

-- Map non-standard categories to the closest standard ones
UPDATE public.service_providers
SET category = 'hair_beauty'
WHERE category ILIKE '%hair%';

-- Map medical-related to appliance_repair (closest match) or keep as is for admin review
-- For now, we'll set medical providers to 'tutoring' as placeholder and mark for review
UPDATE public.service_providers
SET category = 'tutoring', verification_status = 'pending', review_notes = COALESCE(review_notes, '') || ' Category updated from medical. Please select correct category.'
WHERE category ILIKE '%medical%' OR category ILIKE '%doctor%' OR category ILIKE '%health%';

-- Update any remaining providers with invalid categories to use a default (tutoring as placeholder)
-- These providers will need to update their profile through the UI
UPDATE public.service_providers
SET category = 'tutoring', verification_status = 'pending', review_notes = COALESCE(review_notes, '') || ' Category updated. Please select correct category.'
WHERE category NOT IN (
  'plumbing',
  'electrical',
  'cleaning',
  'gardening',
  'painting',
  'carpentry',
  'tutoring',
  'moving',
  'appliance_repair',
  'car_mechanic',
  'hair_beauty',
  'it_support',
  'photography',
  'security',
  'catering'
);

-- Add check constraint to ensure category is one of the valid service categories
ALTER TABLE public.service_providers
ADD CONSTRAINT service_providers_category_check
CHECK (category IN (
  'plumbing',
  'electrical',
  'cleaning',
  'gardening',
  'painting',
  'carpentry',
  'tutoring',
  'moving',
  'appliance_repair',
  'car_mechanic',
  'hair_beauty',
  'it_support',
  'photography',
  'security',
  'catering'
));
