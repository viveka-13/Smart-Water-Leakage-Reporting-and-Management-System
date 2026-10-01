const { successResponse } = require('../utils/response');
const adminService = require('../services/adminService');

async function getComplaints(req, res, next) {
  try {
    const complaints = await adminService.getComplaints({
      status: req.query.status,
      priority: req.query.priority,
    });
    return res.status(200).json(successResponse(complaints, 'Admin complaints fetched successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function getWorkers(req, res, next) {
  try {
    const workers = await adminService.getWorkers();
    return res.status(200).json(successResponse(workers, 'Active workers fetched successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function updateComplaintStatus(req, res, next) {
  try {
    const complaint = await adminService.updateComplaintStatus({
      complaintId: req.params.id,
      status: req.body.status,
      adminId: req.user.id,
      remarks: req.body.remarks,
    });
    return res.status(200).json(successResponse(complaint, 'Complaint status updated successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function assignComplaint(req, res, next) {
  try {
    const assignment = await adminService.assignComplaint({
      complaintId: req.params.id,
      workerId: req.body.workerId,
    });
    return res.status(200).json(successResponse(assignment, 'Complaint assigned successfully.'));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getComplaints,
  getWorkers,
  updateComplaintStatus,
  assignComplaint,
};