const pool = require('../config/database');

async function getSummary() {
  const [summaryRows] = await pool.query(`
    SELECT
      COUNT(*) AS total_complaints,
      SUM(status IN ('REPORTED', 'VERIFIED', 'ASSIGNED', 'IN_PROGRESS', 'REOPENED')) AS open_complaints,
      SUM(status IN ('RESOLVED', 'CLOSED')) AS resolved_complaints,
      ROUND(AVG(CASE WHEN resolved_at IS NOT NULL THEN TIMESTAMPDIFF(HOUR, created_at, resolved_at) END), 2) AS average_resolution_hours
    FROM complaints
  `);
  const [ratingRows] = await pool.query(
    'SELECT ROUND(AVG(rating), 2) AS average_rating, COUNT(*) AS feedback_count FROM feedback',
  );
  const [statusRows] = await pool.query(
    'SELECT status, COUNT(*) AS count FROM complaints GROUP BY status ORDER BY count DESC',
  );
  const [priorityRows] = await pool.query(
    'SELECT priority, COUNT(*) AS count FROM complaints GROUP BY priority ORDER BY count DESC',
  );
  const [categoryRows] = await pool.query(
    'SELECT category, COUNT(*) AS count FROM complaints GROUP BY category ORDER BY count DESC',
  );

  return {
    summary: {
      total_complaints: Number(summaryRows[0]?.total_complaints || 0),
      open_complaints: Number(summaryRows[0]?.open_complaints || 0),
      resolved_complaints: Number(summaryRows[0]?.resolved_complaints || 0),
      average_resolution_hours: Number(summaryRows[0]?.average_resolution_hours || 0),
      average_rating: Number(ratingRows[0]?.average_rating || 0),
      feedback_count: Number(ratingRows[0]?.feedback_count || 0),
    },
    by_status: statusRows,
    by_priority: priorityRows,
    by_category: categoryRows,
  };
}

module.exports = {
  getSummary,
};