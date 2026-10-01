const { successResponse } = require('../utils/response');
const notificationService = require('../services/notificationService');

async function getNotifications(req, res, next) {
  try {
    const notifications = await notificationService.getNotifications(req.user.id);
    return res.status(200).json(successResponse(notifications, 'Notifications fetched successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function markAsRead(req, res, next) {
  try {
    const notification = await notificationService.markNotificationAsRead(req.params.id, req.user.id);
    return res.status(200).json(successResponse(notification, 'Notification marked as read.'));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getNotifications,
  markAsRead,
};