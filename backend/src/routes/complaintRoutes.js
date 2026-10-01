const express = require('express');
const complaintController = require('../controllers/complaintController');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

router.post('/', protect, authorize(['citizen']), complaintController.createComplaint);
router.get('/my', protect, authorize(['citizen']), complaintController.getMyComplaints);
router.get('/:id', protect, authorize(['citizen']), complaintController.getMyComplaintById);

module.exports = router;
