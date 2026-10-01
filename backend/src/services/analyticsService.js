const analyticsRepository = require('../repositories/analyticsRepository');

async function getAdminSummary() {
  return analyticsRepository.getSummary();
}

module.exports = {
  getAdminSummary,
};