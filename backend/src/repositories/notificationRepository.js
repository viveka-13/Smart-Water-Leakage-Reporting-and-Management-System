const pool = require('../config/database');

async function findByUserId(userId) {
  const [rows] = await pool.query(
    'SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC',
    [userId],
  );
  return rows;
}

async function markAsRead(notificationId, userId) {
  const [result] = await pool.query(
    'UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?',
    [notificationId, userId],
  );
  return result.affectedRows > 0;
}

module.exports = {
  findByUserId,
  markAsRead,
};