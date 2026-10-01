const { successResponse } = require('../utils/response');
const complaintService = require('../services/complaintService');

async function createComplaint(req, res, next) {
  try {
    const complaint = await complaintService.createComplaint({
      userId: req.user.id,
      ...req.body,
    });

    return res.status(201).json(
      successResponse(complaint, 'Complaint created successfully.'),
    );
  } catch (error) {
    return next(error);
  }
}

async function getMyComplaints(req, res, next) {
  try {
    const complaints = await complaintService.getMyComplaints(req.user.id);
    return res.status(200).json(
      successResponse(complaints, 'Your complaints fetched successfully.'),
    );
  } catch (error) {
    return next(error);
  }
}

async function getMyComplaintById(req, res, next) {
  try {
    const complaint = await complaintService.getMyComplaintById(req.params.id, req.user.id);
    return res.status(200).json(
      successResponse(complaint, 'Complaint details fetched successfully.'),
    );
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createComplaint,
  getMyComplaints,
  getMyComplaintById,
};
