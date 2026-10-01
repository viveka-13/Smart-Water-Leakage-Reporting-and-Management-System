const feedbackRepository = require('../repositories/feedbackRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

async function createFeedback({ complaintId, userId, rating, comment }) {
  const parsedComplaintId = Number(complaintId);
  if (!Number.isInteger(parsedComplaintId) || parsedComplaintId < 1) {
    throw createError('Complaint ID is invalid.', 400);
  }

  if (!Number.isInteger(rating) || rating < 1 || rating > 5) {
    throw createError('Rating must be an integer from 1 to 5.', 400);
  }

  const complaint = await feedbackRepository.findComplaintForUser(parsedComplaintId, userId);
  if (!complaint) throw createError('Complaint not found.', 404);
  if (!['RESOLVED', 'CLOSED'].includes(complaint.status)) {
    throw createError('Feedback can be submitted after complaint resolution.', 400);
  }

  const existingFeedback = await feedbackRepository.findByComplaintAndUser(parsedComplaintId, userId);
  if (existingFeedback) throw createError('Feedback has already been submitted.', 409);

  return feedbackRepository.create({
    complaintId: parsedComplaintId,
    userId,
    rating,
    comment: comment ? String(comment).trim() : null,
  });
}

module.exports = {
  createFeedback,
};