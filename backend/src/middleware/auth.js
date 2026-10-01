const jwt = require('jsonwebtoken');
const config = require('../config/env');
const userRepository = require('../repositories/userRepository');
const { errorResponse } = require('../utils/response');

async function protect(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json(errorResponse('Authentication token is missing or invalid.'));
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, config.jwtSecret);
    const user = await userRepository.findById(decoded.id);

    if (!user) {
      return res.status(401).json(errorResponse('User not found for this token.'));
    }

    if (!user.is_active) {
      return res.status(403).json(errorResponse('User account is inactive.'));
    }

    req.user = {
      id: user.id,
      email: user.email,
      role: user.role,
    };

    return next();
  } catch (error) {
    return res.status(401).json(errorResponse('Token is invalid or expired.'));
  }
}

function authorize(allowedRoles = []) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json(errorResponse('Authentication required.'));
    }

    if (!allowedRoles.length) {
      return next();
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json(errorResponse('You do not have permission to access this resource.'));
    }

    return next();
  };
}

module.exports = {
  protect,
  authorize,
};
