const { errorResponse } = require('../utils/response');

function notFoundHandler(req, res) {
  res.status(404).json(
    errorResponse('Route not found', {
      path: req.originalUrl,
      method: req.method,
    }),
  );
}

function globalErrorHandler(err, req, res, next) {
  if (res.headersSent) {
    return next(err);
  }

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal server error';

  res.status(statusCode).json(
    errorResponse(message, {
      path: req.originalUrl,
      method: req.method,
    }),
  );
}

module.exports = {
  notFoundHandler,
  globalErrorHandler,
};
