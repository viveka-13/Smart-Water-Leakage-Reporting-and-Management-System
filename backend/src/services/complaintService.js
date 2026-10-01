const complaintRepository = require('../repositories/complaintRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

function validateComplaint({ title, category, description, priority, latitude, longitude, address }) {
  if (!title || !String(title).trim()) {
    throw createError('Complaint title is required.', 400);
  }

  if (String(title).trim().length < 5) {
    throw createError('Complaint title must be at least 5 characters long.', 400);
  }

  if (!category || !String(category).trim()) {
    throw createError('Complaint category is required.', 400);
  }

  const validCategories = [
    'PIPE_LEAKAGE',
    'TANK_OVERFLOW',
    'DAMAGED_PIPELINE',
    'DRAINAGE_BLOCKAGE',
    'CONTAMINATED_WATER',
    'LOW_WATER_PRESSURE',
    'ILLEGAL_CONNECTION',
    'OTHER',
  ];

  if (!validCategories.includes(category)) {
    throw createError('Complaint category is invalid.', 400);
  }

  if (!description || !String(description).trim()) {
    throw createError('Complaint description is required.', 400);
  }

  if (String(description).trim().length < 10) {
    throw createError('Complaint description must be at least 10 characters long.', 400);
  }

  const validPriorities = ['LOW', 'MEDIUM', 'HIGH', 'EMERGENCY'];
  if (priority && !validPriorities.includes(priority)) {
    throw createError('Complaint priority is invalid.', 400);
  }

  if ((latitude === undefined || latitude === null || latitude === '') || (longitude === undefined || longitude === null || longitude === '')) {
    throw createError('Latitude and longitude are required.', 400);
  }

  const parsedLatitude = Number(latitude);
  const parsedLongitude = Number(longitude);
  if (!Number.isFinite(parsedLatitude) || parsedLatitude < -90 || parsedLatitude > 90) {
    throw createError('Latitude must be between -90 and 90.', 400);
  }
  if (!Number.isFinite(parsedLongitude) || parsedLongitude < -180 || parsedLongitude > 180) {
    throw createError('Longitude must be between -180 and 180.', 400);
  }

  if (!address || !String(address).trim()) {
    throw createError('Address is required.', 400);
  }

  return true;
}

async function createComplaint(data) {
  validateComplaint(data);

  const complaint = await complaintRepository.createComplaint({
    userId: data.userId,
    category: data.category,
    title: String(data.title).trim(),
    description: String(data.description).trim(),
    priority: data.priority || 'MEDIUM',
    latitude: Number(data.latitude),
    longitude: Number(data.longitude),
    address: String(data.address).trim(),
    imageUrl: data.imageUrl || null,
    syncedFromOffline: data.syncedFromOffline === true || data.synced_from_offline === true,
  });

  return complaint;
}

async function getMyComplaints(userId) {
  return complaintRepository.findByUserId(userId);
}

async function getMyComplaintById(complaintId, userId) {
  const parsedComplaintId = Number(complaintId);

  if (!Number.isInteger(parsedComplaintId) || parsedComplaintId < 1) {
    throw createError('Complaint ID is invalid.', 400);
  }

  const complaint = await complaintRepository.findByIdAndUserId(parsedComplaintId, userId);

  if (!complaint) {
    throw createError('Complaint not found.', 404);
  }

  return complaint;
}

module.exports = {
  createComplaint,
  getMyComplaints,
  getMyComplaintById,
};
