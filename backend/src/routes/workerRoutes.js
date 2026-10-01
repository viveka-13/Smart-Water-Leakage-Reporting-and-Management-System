const express = require('express');
const workerController = require('../controllers/workerController');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();
const workerOnly = [protect, authorize(['worker'])];

router.get('/complaints', ...workerOnly, workerController.getAssignedComplaints);
router.patch('/complaints/:id/status', ...workerOnly, workerController.updateAssignedComplaint);

module.exports = router;