const { successResponse } = require('../utils/response');
const analyticsService = require('../services/analyticsService');

async function getAdminSummary(req, res, next) {
  try {
    const summary = await analyticsService.getAdminSummary();
    return res.status(200).json(successResponse(summary, 'Analytics summary fetched successfully.'));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getAdminSummary,
};