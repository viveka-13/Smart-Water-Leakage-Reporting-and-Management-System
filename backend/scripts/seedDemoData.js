const bcrypt = require('bcryptjs');
const pool = require('../src/config/database');

const demoPassword = 'AquaGuard123!';
const demoUsers = [
  { name: 'AquaGuard Citizen', email: 'citizen@aquaguard.demo', role: 'citizen' },
  { name: 'AquaGuard Admin', email: 'admin@aquaguard.demo', role: 'admin' },
  { name: 'AquaGuard Field Worker', email: 'worker@aquaguard.demo', role: 'worker' },
];

async function getOrCreateUser({ name, email, role }, passwordHash) {
  const [rows] = await pool.query('SELECT id FROM users WHERE email = ? LIMIT 1', [email]);
  if (rows[0]) {
    await pool.query(
      'UPDATE users SET name = ?, role = ?, password_hash = ?, is_active = TRUE WHERE id = ?',
      [name, role, passwordHash, rows[0].id],
    );
    return rows[0].id;
  }

  const [result] = await pool.query(
    'INSERT INTO users (name, email, password_hash, role, is_active) VALUES (?, ?, ?, ?, TRUE)',
    [name, email, passwordHash, role],
  );
  return result.insertId;
}

async function getOrCreateComplaint({ userId, workerId, title, category, status, priority, address, latitude, longitude }) {
  const [rows] = await pool.query(
    'SELECT id FROM complaints WHERE user_id = ? AND title = ? LIMIT 1',
    [userId, title],
  );
  if (rows[0]) return rows[0].id;

  const resolvedAt = status === 'RESOLVED' ? new Date() : null;
  const [result] = await pool.query(
    `INSERT INTO complaints
      (user_id, assigned_worker_id, category, title, description, priority, status, address, latitude, longitude, resolved_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      userId,
      workerId,
      category,
      title,
      'Academic demonstration record for the AquaGuard workflow.',
      priority,
      status,
      address,
      latitude,
      longitude,
      resolvedAt,
    ],
  );
  return result.insertId;
}

async function seed() {
  const passwordHash = await bcrypt.hash(demoPassword, 10);
  const userIds = {};
  for (const user of demoUsers) {
    userIds[user.role] = await getOrCreateUser(user, passwordHash);
  }

  const assignedComplaintId = await getOrCreateComplaint({
    userId: userIds.citizen,
    workerId: userIds.worker,
    title: 'Demo: pipeline leak near the community hall',
    category: 'PIPE_LEAKAGE',
    status: 'IN_PROGRESS',
    priority: 'HIGH',
    address: 'Community Hall, Demo Ward',
    latitude: 19.076,
    longitude: 72.8777,
  });
  const resolvedComplaintId = await getOrCreateComplaint({
    userId: userIds.citizen,
    workerId: userIds.worker,
    title: 'Demo: overhead tank overflow',
    category: 'TANK_OVERFLOW',
    status: 'RESOLVED',
    priority: 'MEDIUM',
    address: 'Demo Ward Water Tank',
    latitude: 19.08,
    longitude: 72.88,
  });
  await getOrCreateComplaint({
    userId: userIds.citizen,
    workerId: userIds.worker,
    title: 'Demo: low water pressure repair awaiting feedback',
    category: 'LOW_WATER_PRESSURE',
    status: 'RESOLVED',
    priority: 'LOW',
    address: 'Demo Ward, Block C',
    latitude: 19.081,
    longitude: 72.881,
  });

  const [historyRows] = await pool.query(
    'SELECT id FROM complaint_status_history WHERE complaint_id = ? LIMIT 1',
    [assignedComplaintId],
  );
  if (!historyRows[0]) {
    await pool.query(
      `INSERT INTO complaint_status_history
        (complaint_id, changed_by, old_status, new_status, remarks)
        VALUES (?, ?, 'ASSIGNED', 'IN_PROGRESS', 'Demo worker started site inspection.')`,
      [assignedComplaintId, userIds.worker],
    );
  }

  const [notificationRows] = await pool.query(
    'SELECT id FROM notifications WHERE user_id = ? AND complaint_id = ? LIMIT 1',
    [userIds.citizen, assignedComplaintId],
  );
  if (!notificationRows[0]) {
    await pool.query(
      `INSERT INTO notifications
        (user_id, complaint_id, title, message, notification_type)
        VALUES (?, ?, 'Work in progress', 'A field worker has started work on your report.', 'STATUS_UPDATE')`,
      [userIds.citizen, assignedComplaintId],
    );
  }

  const [feedbackRows] = await pool.query(
    'SELECT id FROM feedback WHERE complaint_id = ? AND user_id = ? LIMIT 1',
    [resolvedComplaintId, userIds.citizen],
  );
  if (!feedbackRows[0]) {
    await pool.query(
      'INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES (?, ?, 5, ?)',
      [resolvedComplaintId, userIds.citizen, 'Demo feedback: the repair was completed promptly.'],
    );
  }

  console.log('AquaGuard demo data is ready.');
  console.log(`Demo password for all roles: ${demoPassword}`);
  for (const user of demoUsers) console.log(`${user.role}: ${user.email}`);
}

seed()
  .catch((error) => {
    console.error('Unable to seed AquaGuard demo data:', error.message);
    process.exitCode = 1;
  })
  .finally(async () => {
    await pool.end();
  });