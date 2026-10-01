const { successResponse } = require('../utils/response');
const feedbackService = require('../services/feedbackService');

async function createFeedback(req, res, next) {
  try {
    const feedback = await feedbackService.createFeedback({
      complaintId: req.params.complaintId,
      userId: req.user.id,
      rating: req.body.rating,
      comment: req.body.comment,
    });
    return res.status(201).json(successResponse(feedback, 'Feedback submitted successfully.'));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createFeedback,
};