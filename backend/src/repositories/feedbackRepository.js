const pool = require('../config/database');

async function findComplaintForUser(complaintId, userId) {
  const [rows] = await pool.query(
    'SELECT id, status FROM complaints WHERE id = ? AND user_id = ? LIMIT 1',
    [complaintId, userId],
  );
  return rows[0] || null;
}

async function findByComplaintAndUser(complaintId, userId) {
  const [rows] = await pool.query(
    'SELECT * FROM feedback WHERE complaint_id = ? AND user_id = ? LIMIT 1',
    [complaintId, userId],
  );
  return rows[0] || null;
}

async function create({ complaintId, userId, rating, comment }) {
  const [result] = await pool.query(
    'INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES (?, ?, ?, ?)',
    [complaintId, userId, rating, comment || null],
  );
  return {
    id: result.insertId,
    complaint_id: complaintId,
    user_id: userId,
    rating,
    comment: comment || null,
  };
}

module.exports = {
  findComplaintForUser,
  findByComplaintAndUser,
  create,
};