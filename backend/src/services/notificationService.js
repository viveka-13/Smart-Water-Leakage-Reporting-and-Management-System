const notificationRepository = require('../repositories/notificationRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

function parseId(value, label) {
  const id = Number(value);
  if (!Number.isInteger(id) || id < 1) throw createError(`${label} is invalid.`, 400);
  return id;
}

async function getNotifications(userId) {
  return notificationRepository.findByUserId(userId);
}

async function markNotificationAsRead(notificationId, userId) {
  const updated = await notificationRepository.markAsRead(parseId(notificationId, 'Notification ID'), userId);
  if (!updated) throw createError('Notification not found.', 404);
  return { id: Number(notificationId), is_read: true };
}

module.exports = {
  getNotifications,
  markNotificationAsRead,
};