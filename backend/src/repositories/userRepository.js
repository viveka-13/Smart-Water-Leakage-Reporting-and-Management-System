const pool = require('../config/database');

async function findByEmail(email) {
  const [rows] = await pool.query(
    'SELECT * FROM users WHERE email = ? LIMIT 1',
    [email],
  );

  return rows[0] || null;
}

async function findById(id) {
  const [rows] = await pool.query(
    'SELECT * FROM users WHERE id = ? LIMIT 1',
    [id],
  );

  return rows[0] || null;
}

async function findActiveWorkers() {
  const [rows] = await pool.query(
    "SELECT id, name, email, phone FROM users WHERE role = 'worker' AND is_active = TRUE ORDER BY name ASC",
  );

  return rows;
}

async function findActiveWorkerById(id) {
  const [rows] = await pool.query(
    "SELECT id, name, email, phone FROM users WHERE id = ? AND role = 'worker' AND is_active = TRUE LIMIT 1",
    [id],
  );

  return rows[0] || null;
}

async function createUser({ name, email, phone, passwordHash, role }) {
  const [result] = await pool.query(
    'INSERT INTO users (name, email, phone, password_hash, role, is_active) VALUES (?, ?, ?, ?, ?, TRUE)',
    [name, email, phone, passwordHash, role],
  );

  return {
    id: result.insertId,
    name,
    email,
    phone,
    role,
    is_active: true,
  };
}

module.exports = {
  findByEmail,
  findById,
  findActiveWorkers,
  findActiveWorkerById,
  createUser,
};
