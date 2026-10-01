const complaintRepository = require('../repositories/complaintRepository');
const userRepository = require('../repositories/userRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

const validStatuses = [
  'REPORTED',
  'VERIFIED',
  'ASSIGNED',
  'IN_PROGRESS',
  'RESOLVED',
  'REOPENED',
  'CLOSED',
  'REJECTED',
];

const validPriorities = ['LOW', 'MEDIUM', 'HIGH', 'EMERGENCY'];

function parseId(value, label) {
  const id = Number(value);
  if (!Number.isInteger(id) || id < 1) {
    throw createError(`${label} is invalid.`, 400);
  }
  return id;
}

async function getComplaints(filters) {
  if (filters.status && !validStatuses.includes(filters.status)) {
    throw createError('Complaint status is invalid.', 400);
  }
  if (filters.priority && !validPriorities.includes(filters.priority)) {
    throw createError('Complaint priority is invalid.', 400);
  }

  return complaintRepository.findAll(filters);
}

async function getWorkers() {
  return userRepository.findActiveWorkers();
}

async function updateComplaintStatus({ complaintId, status, adminId, remarks }) {
  const id = parseId(complaintId, 'Complaint ID');
  if (!validStatuses.includes(status)) {
    throw createError('Complaint status is invalid.', 400);
  }

  const updatedComplaint = await complaintRepository.updateStatus({
    complaintId: id,
    status,
    adminId,
    remarks,
  });

  if (!updatedComplaint) {
    throw createError('Complaint not found.', 404);
  }

  return updatedComplaint;
}

async function assignComplaint({ complaintId, workerId }) {
  const complaintIdNumber = parseId(complaintId, 'Complaint ID');
  const workerIdNumber = parseId(workerId, 'Worker ID');
  const worker = await userRepository.findActiveWorkerById(workerIdNumber);

  if (!worker) {
    throw createError('Active field worker not found.', 404);
  }

  const assignment = await complaintRepository.assignWorker({
    complaintId: complaintIdNumber,
    workerId: workerIdNumber,
  });

  if (!assignment) {
    throw createError('Complaint not found.', 404);
  }

  return { ...assignment, worker };
}

module.exports = {
  getComplaints,
  getWorkers,
  updateComplaintStatus,
  assignComplaint,
};