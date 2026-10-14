const app = require('./app');
const config = require('./config/env');

app.listen(config.port, '0.0.0.0', () => {
  console.log(`AquaGuard backend running on port ${config.port}`);
});
