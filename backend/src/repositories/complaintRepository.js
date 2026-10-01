const pool = require('../config/database');

async function createComplaint({
  userId,
  category,
  title,
  description,
  priority,
  latitude,
  longitude,
  address,
  imageUrl,
  syncedFromOffline,
}) {
  const [result] = await pool.query(
    `INSERT INTO complaints
      (user_id, category, title, description, priority, status, latitude, longitude, address, image_url, synced_from_offline)
      VALUES (?, ?, ?, ?, ?, 'REPORTED', ?, ?, ?, ?, ?)`,
    [userId, category, title, description, priority, latitude || null, longitude || null, address || null, imageUrl || null, syncedFromOffline === true],
  );

  return {
    id: result.insertId,
    user_id: userId,
    category,
    title,
    description,
    priority,
    status: 'REPORTED',
    latitude: latitude || null,
    longitude: longitude || null,
    address: address || null,
    image_url: imageUrl || null,
    synced_from_offline: syncedFromOffline === true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };
}

async function findByUserId(userId) {
  const [rows] = await pool.query(
    'SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC',
    [userId],
  );

  return rows;
}

async function findByIdAndUserId(complaintId, userId) {
  const [rows] = await pool.query(
    'SELECT * FROM complaints WHERE id = ? AND user_id = ? LIMIT 1',
    [complaintId, userId],
  );

  return rows[0] || null;
}

async function findAll({ status, priority } = {}) {
  let query = 'SELECT * FROM complaints WHERE 1 = 1';
  const values = [];

  if (status) {
    query += ' AND status = ?';
    values.push(status);
  }

  if (priority) {
    query += ' AND priority = ?';
    values.push(priority);
  }

  query += ' ORDER BY created_at DESC';
  const [rows] = await pool.query(query, values);
  return rows;
}

async function updateStatus({ complaintId, status, adminId, remarks }) {
  const [currentRows] = await pool.query(
    'SELECT status FROM complaints WHERE id = ? LIMIT 1',
    [complaintId],
  );

  if (!currentRows[0]) {
    return null;
  }

  await pool.query(
    'UPDATE complaints SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
    [status, complaintId],
  );
  await pool.query(
    `INSERT INTO complaint_status_history
      (complaint_id, changed_by, old_status, new_status, remarks)
      VALUES (?, ?, ?, ?, ?)`,
    [complaintId, adminId, currentRows[0].status, status, remarks || null],
  );

  return {
    id: complaintId,
    status,
    old_status: currentRows[0].status,
    remarks: remarks || null,
  };
}

async function assignWorker({ complaintId, workerId }) {
  const [result] = await pool.query(
    "UPDATE complaints SET assigned_worker_id = ?, status = 'ASSIGNED', updated_at = CURRENT_TIMESTAMP WHERE id = ?",
    [workerId, complaintId],
  );

  if (!result.affectedRows) {
    return null;
  }

  return {
    id: complaintId,
    assigned_worker_id: workerId,
    status: 'ASSIGNED',
  };
}

async function findAssignedToWorker(workerId) {
  const [rows] = await pool.query(
    'SELECT * FROM complaints WHERE assigned_worker_id = ? ORDER BY priority DESC, created_at ASC',
    [workerId],
  );

  return rows;
}

async function updateWorkerStatus({ complaintId, workerId, status, remarks }) {
  const [currentRows] = await pool.query(
    'SELECT status FROM complaints WHERE id = ? AND assigned_worker_id = ? LIMIT 1',
    [complaintId, workerId],
  );

  if (!currentRows[0]) {
    return null;
  }

  await pool.query(
    'UPDATE complaints SET status = ?, updated_at = CURRENT_TIMESTAMP, resolved_at = CASE WHEN ? = \'RESOLVED\' THEN CURRENT_TIMESTAMP ELSE resolved_at END WHERE id = ? AND assigned_worker_id = ?',
    [status, status, complaintId, workerId],
  );
  await pool.query(
    `INSERT INTO complaint_status_history
      (complaint_id, changed_by, old_status, new_status, remarks)
      VALUES (?, ?, ?, ?, ?)`,
    [complaintId, workerId, currentRows[0].status, status, remarks || null],
  );

  return {
    id: complaintId,
    status,
    old_status: currentRows[0].status,
    remarks: remarks || null,
  };
}

module.exports = {
  createComplaint,
  findByUserId,
  findByIdAndUserId,
  findAll,
  updateStatus,
  assignWorker,
  findAssignedToWorker,
  updateWorkerStatus,
};
