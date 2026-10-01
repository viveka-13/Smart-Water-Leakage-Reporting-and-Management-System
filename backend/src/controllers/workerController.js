const { successResponse } = require('../utils/response');
const workerService = require('../services/workerService');

async function getAssignedComplaints(req, res, next) {
  try {
    const complaints = await workerService.getAssignedComplaints(req.user.id);
    return res.status(200).json(successResponse(complaints, 'Assigned complaints fetched successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function updateAssignedComplaint(req, res, next) {
  try {
    const complaint = await workerService.updateAssignedComplaint({
      complaintId: req.params.id,
      workerId: req.user.id,
      status: req.body.status,
      remarks: req.body.remarks,
    });
    return res.status(200).json(successResponse(complaint, 'Work progress updated successfully.'));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getAssignedComplaints,
  updateAssignedComplaint,
};