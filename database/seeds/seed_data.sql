USE aquaguard;

INSERT INTO complaint_categories (name, description, is_active)
VALUES
  ('PIPE_LEAKAGE', 'Leakage in supply line or joints', TRUE),
  ('TANK_OVERFLOW', 'Overflowing or broken storage tank', TRUE),
  ('DAMAGED_PIPELINE', 'Pipeline damaged due to wear or accident', TRUE),
  ('DRAINAGE_BLOCKAGE', 'Blocked drainage or sewer flow', TRUE),
  ('CONTAMINATED_WATER', 'Water contamination or bad smell', TRUE),
  ('LOW_WATER_PRESSURE', 'Very low or no water pressure', TRUE),
  ('ILLEGAL_CONNECTION', 'Unauthorized water connection or tampering', TRUE),
  ('OTHER', 'Other water-related issue', TRUE)
ON DUPLICATE KEY UPDATE name = name;

INSERT INTO users (name, email, phone, password_hash, role, is_active)
VALUES
  ('System Admin', 'admin@aquaguard.com', '9000000001', '$2a$10$8q1Y8Pp1yA5P2c0EJz0S8e8GX7R0R0G44nFvQF6gA1YQ8P6F7hK1m', 'admin', TRUE),
  ('Citizen One', 'citizen1@aquaguard.com', '9000000002', '$2a$10$8q1Y8Pp1yA5P2c0EJz0S8e8GX7R0R0G44nFvQF6gA1YQ8P6F7hK1m', 'citizen', TRUE),
  ('Field Worker One', 'worker1@aquaguard.com', '9000000003', '$2a$10$8q1Y8Pp1yA5P2c0EJz0S8e8GX7R0R0G44nFvQF6gA1YQ8P6F7hK1m', 'worker', TRUE)
ON DUPLICATE KEY UPDATE email = email;
