const express = require('express');
const adminController = require('../controllers/adminController');
const analyticsController = require('../controllers/analyticsController');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();
const adminOnly = [protect, authorize(['admin'])];

router.get('/complaints', ...adminOnly, adminController.getComplaints);
router.get('/workers', ...adminOnly, adminController.getWorkers);
router.get('/analytics/summary', ...adminOnly, analyticsController.getAdminSummary);
router.patch('/complaints/:id/status', ...adminOnly, adminController.updateComplaintStatus);
router.patch('/complaints/:id/assign', ...adminOnly, adminController.assignComplaint);

module.exports = router;