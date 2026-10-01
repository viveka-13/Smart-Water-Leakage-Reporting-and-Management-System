const express = require('express');
const feedbackController = require('../controllers/feedbackController');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

router.post('/complaints/:complaintId', protect, authorize(['citizen']), feedbackController.createFeedback);

module.exports = router;