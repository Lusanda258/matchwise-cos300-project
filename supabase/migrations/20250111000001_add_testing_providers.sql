-- Insert testing service providers for development/testing
-- These providers have valid categories from the predefined list

-- This version temporarily disables the foreign key constraint to allow testing without real users
-- For production, you should have real users linked to these providers

-- Temporarily disable the foreign key constraint
ALTER TABLE public.service_providers DROP CONSTRAINT IF EXISTS service_providers_user_id_fkey;

-- Insert testing providers using a placeholder user_id
-- These providers can be linked to real users later if needed
INSERT INTO public.service_providers (
  user_id,
  business_name,
  category,
  bio,
  hourly_rate,
  location,
  service_radius_km,
  status,
  verification_status,
  avg_rating,
  rating_count,
  review_notes,
  business_registration_number
) VALUES
-- Plumbing providers
('00000000-0000-0000-0000-000000000001', 'Pretoria Plumbing Services', 'plumbing', 'Professional plumbing services for residential and commercial properties. Specializing in leak detection, pipe repairs, and geyser installations.', 450.00, 'Pretoria', 50, 'online', 'verified', 4.5, 12, NULL, 'PL2024/001'),
('00000000-0000-0000-0000-000000000002', 'Johannesburg Emergency Plumbers', 'plumbing', '24/7 emergency plumbing services. Fast response time for burst pipes, blocked drains, and geyser repairs.', 550.00, 'Johannesburg', 30, 'online', 'verified', 4.8, 28, NULL, 'PL2024/002'),

-- Electrical providers
('00000000-0000-0000-0000-000000000003', 'Spark Electricians', 'electrical', 'Licensed electricians for all your electrical needs. Installations, repairs, maintenance, and inspections.', 400.00, 'Cape Town', 40, 'online', 'verified', 4.6, 15, NULL, 'EL2024/001'),
('00000000-0000-0000-0000-000000000004', 'Power Grid Solutions', 'electrical', 'Commercial and industrial electrical services. Solar installations, wiring upgrades, and electrical compliance.', 600.00, 'Durban', 60, 'offline', 'verified', 4.3, 8, NULL, 'EL2024/002'),

-- Cleaning providers
('00000000-0000-0000-0000-000000000005', 'Spotless Cleaning Co', 'cleaning', 'Professional cleaning services for homes and offices. Deep cleaning, regular maintenance, and move-in/out cleaning.', 250.00, 'Pretoria', 25, 'online', 'verified', 4.7, 22, NULL, 'CL2024/001'),
('00000000-0000-0000-0000-000000000006', 'Green Clean Services', 'cleaning', 'Eco-friendly cleaning solutions. Safe for families and pets. Window cleaning, carpet cleaning, and general cleaning.', 300.00, 'Johannesburg', 20, 'online', 'pending', 0.0, 0, NULL, 'CL2024/002'),

-- Gardening providers
('00000000-0000-0000-0000-000000000007', 'Lush Landscaping', 'gardening', 'Full landscaping services. Garden design, lawn care, tree trimming, irrigation systems, and garden maintenance.', 350.00, 'Cape Town', 35, 'online', 'verified', 4.9, 35, NULL, 'GD2024/001'),
('00000000-0000-0000-0000-000000000008', 'Garden Warriors', 'gardening', 'Affordable gardening services. Lawn mowing, hedge trimming, weeding, and general garden upkeep.', 200.00, 'Durban', 15, 'online', 'verified', 4.4, 18, NULL, 'GD2024/002'),

-- Painting providers
('00000000-0000-0000-0000-000000000009', 'Color Palette Painters', 'painting', 'Professional painting services. Interior and exterior painting, wallpapering, and decorative finishes.', 380.00, 'Pretoria', 30, 'online', 'verified', 4.5, 14, NULL, 'PT2024/001'),
('00000000-0000-0000-0000-000000000010', 'Fresh Coat Painting', 'painting', 'High-quality painting for homes and businesses. Color consultation, surface preparation, and clean finishes.', 420.00, 'Johannesburg', 40, 'online', 'pending', 0.0, 0, NULL, 'PT2024/002'),

-- Carpentry providers
('00000000-0000-0000-0000-000000000011', 'Master Woodworks', 'carpentry', 'Custom carpentry and joinery. Furniture making, kitchen cabinets, built-in wardrobes, and repairs.', 450.00, 'Cape Town', 25, 'online', 'verified', 4.8, 20, NULL, 'CP2024/001'),
('00000000-0000-0000-0000-000000000012', 'Quick Fix Carpentry', 'carpentry', 'General carpentry repairs and installations. Door hanging, shelving, decking, and structural repairs.', 350.00, 'Durban', 30, 'online', 'verified', 4.2, 11, NULL, 'CP2024/002'),

-- Tutoring providers
('00000000-0000-0000-0000-000000000013', 'Academic Excellence Tutors', 'tutoring', 'Professional tutoring for all subjects and grades. Mathematics, science, languages, and exam preparation.', 280.00, 'Pretoria', 20, 'online', 'verified', 4.9, 45, NULL, 'TT2024/001'),
('00000000-0000-0000-0000-000000000014', 'Math Wizards', 'tutoring', 'Specialized mathematics tutoring. From primary school to university level. Problem-solving and exam techniques.', 320.00, 'Johannesburg', 25, 'online', 'verified', 4.7, 33, NULL, 'TT2024/002'),

-- Moving providers
('00000000-0000-0000-0000-000000000015', 'Safe Move Logistics', 'moving', 'Professional moving services. Packing, loading, transportation, and unpacking. Local and long-distance moves.', 500.00, 'Cape Town', 100, 'online', 'verified', 4.6, 25, NULL, 'MV2024/001'),
('00000000-0000-0000-0000-000000000016', 'Budget Movers', 'moving', 'Affordable moving solutions. Student moves, small apartments, and office relocations. Friendly and efficient.', 350.00, 'Durban', 50, 'online', 'pending', 0.0, 0, NULL, 'MV2024/002'),

-- Appliance repair providers
('00000000-0000-0000-0000-000000000017', 'Fix-It Appliance Repair', 'appliance_repair', 'Expert appliance repair services. Fridges, washing machines, dishwashers, ovens, and microwaves.', 400.00, 'Pretoria', 30, 'online', 'verified', 4.5, 19, NULL, 'AP2024/001'),
('00000000-0000-0000-0000-000000000018', 'Quick Fix Appliances', 'appliance_repair', 'Fast and reliable appliance repairs. All major brands. Same-day service available.', 450.00, 'Johannesburg', 25, 'online', 'verified', 4.3, 16, NULL, 'AP2024/002'),

-- Car mechanic providers
('00000000-0000-0000-0000-000000000019', 'Auto Care Center', 'car_mechanic', 'Full-service auto repair and maintenance. Engine diagnostics, brake service, oil changes, and general repairs.', 380.00, 'Cape Town', 20, 'online', 'verified', 4.7, 42, NULL, 'CM2024/001'),
('00000000-0000-0000-0000-000000000020', 'Mobile Mechanics', 'car_mechanic', 'We come to you! Mobile car repair and maintenance services. Convenient and affordable.', 420.00, 'Durban', 30, 'online', 'verified', 4.4, 23, NULL, 'CM2024/002'),

-- Hair & beauty providers
('00000000-0000-0000-0000-000000000021', 'Glamour Hair Studio', 'hair_beauty', 'Full-service hair salon. Haircuts, coloring, styling, treatments, and bridal services.', 350.00, 'Pretoria', 15, 'online', 'verified', 4.8, 56, NULL, 'HB2024/001'),
('00000000-0000-0000-0000-000000000022', 'Beauty Bliss Spa', 'hair_beauty', 'Hair and beauty services. Styling, manicures, pedicures, facials, and makeup for special occasions.', 400.00, 'Johannesburg', 20, 'online', 'verified', 4.6, 38, NULL, 'HB2024/002'),

-- IT support providers
('00000000-0000-0000-0000-000000000023', 'Tech Support Pros', 'it_support', 'Professional IT support for home and business. Computer repairs, network setup, virus removal, and software installation.', 450.00, 'Cape Town', 25, 'online', 'verified', 4.7, 29, NULL, 'IT2024/001'),
('00000000-0000-0000-0000-000000000024', 'Geek Squad SA', 'it_support', 'On-site and remote IT support. Hardware and software troubleshooting, data recovery, and cybersecurity.', 500.00, 'Durban', 30, 'online', 'pending', 0.0, 0, NULL, 'IT2024/002'),

-- Photography providers
('00000000-0000-0000-0000-000000000025', 'Capture Moments Photography', 'photography', 'Professional photography services. Weddings, events, portraits, product photography, and real estate.', 600.00, 'Pretoria', 50, 'online', 'verified', 4.9, 47, NULL, 'PH2024/001'),
('00000000-0000-0000-0000-000000000026', 'Shutterbug Studios', 'photography', 'Creative photography for all occasions. Family portraits, corporate events, and commercial photography.', 550.00, 'Johannesburg', 40, 'online', 'verified', 4.5, 21, NULL, 'PH2024/002'),

-- Security providers
('00000000-0000-0000-0000-000000000027', 'SecureGuard Security', 'security', 'Professional security services. Armed guards, patrol services, alarm installation, and CCTV monitoring.', 450.00, 'Cape Town', 30, 'online', 'verified', 4.6, 31, NULL, 'SC2024/001'),
('00000000-0000-0000-0000-000000000028', 'Night Watch Security', 'security', 'Night-time security services. Patrol services, event security, and overnight monitoring.', 400.00, 'Durban', 25, 'online', 'verified', 4.4, 18, NULL, 'SC2024/002'),

-- Catering providers
('00000000-0000-0000-0000-000000000029', 'Gourmet Catering Co', 'catering', 'Premium catering services for weddings, corporate events, and parties. Custom menus and dietary options.', 500.00, 'Pretoria', 40, 'online', 'verified', 4.8, 52, NULL, 'CT2024/001'),
('00000000-0000-0000-0000-000000000030', 'Home Style Catering', 'catering', 'Homestyle catering for intimate gatherings and small events. Comfort food and traditional dishes.', 380.00, 'Johannesburg', 30, 'online', 'verified', 4.5, 27, NULL, 'CT2024/002')
ON CONFLICT (user_id, business_name) DO NOTHING;

-- Re-enable the foreign key constraint (will only work if auth.users table exists)
-- Comment this out if you don't have auth.users set up yet
DO $$
BEGIN
  -- Try to add the constraint back if auth.users exists
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'auth' AND table_name = 'users') THEN
    ALTER TABLE public.service_providers
    ADD CONSTRAINT service_providers_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Could not re-add foreign key constraint. This is OK for testing.';
END $$;
