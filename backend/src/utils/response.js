function successResponse(data = null, message = 'success') {
  return {
    success: true,
    data,
    error: null,
    message,
  };
}

function errorResponse(message = 'Something went wrong', details = null) {
  return {
    success: false,
    data: null,
    error: {
      message,
      details,
    },
  };
}

module.exports = {
  successResponse,
  errorResponse,
};
