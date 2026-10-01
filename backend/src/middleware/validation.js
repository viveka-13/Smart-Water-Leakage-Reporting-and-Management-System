function validateRequest(schema) {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });

    if (error) {
      const messages = error.details.map((detail) => detail.message);
      return res.status(400).json({
        success: false,
        data: null,
        error: {
          message: 'Validation failed',
          details: messages,
        },
      });
    }

    next();
  };
}

module.exports = {
  validateRequest,
};
