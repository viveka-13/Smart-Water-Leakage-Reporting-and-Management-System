const complaintRepository = require('../repositories/complaintRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

const workerStatuses = ['IN_PROGRESS', 'RESOLVED'];

function parseId(value) {
  const id = Number(value);
  if (!Number.isInteger(id) || id < 1) {
    throw createError('Complaint ID is invalid.', 400);
  }
  return id;
}

async function getAssignedComplaints(workerId) {
  return complaintRepository.findAssignedToWorker(workerId);
}

async function updateAssignedComplaint({ complaintId, workerId, status, remarks }) {
  const id = parseId(complaintId);

  if (!workerStatuses.includes(status)) {
    throw createError('Worker status is invalid.', 400);
  }

  const updatedComplaint = await complaintRepository.updateWorkerStatus({
    complaintId: id,
    workerId,
    status,
    remarks,
  });

  if (!updatedComplaint) {
    throw createError('Assigned complaint not found.', 404);
  }

  return updatedComplaint;
}

module.exports = {
  getAssignedComplaints,
  updateAssignedComplaint,
};