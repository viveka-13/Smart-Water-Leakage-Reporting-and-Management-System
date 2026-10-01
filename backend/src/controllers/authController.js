const { successResponse } = require('../utils/response');
const authService = require('../services/authService');

async function register(req, res, next) {
  try {
    const result = await authService.registerUser(req.body);
    return res.status(201).json(
      successResponse({ user: result.user, token: result.token }, 'Registration successful.'),
    );
  } catch (error) {
    return next(error);
  }
}

async function login(req, res, next) {
  try {
    const result = await authService.loginUser(req.body);
    return res.status(200).json(
      successResponse({ user: result.user, token: result.token }, 'Login successful.'),
    );
  } catch (error) {
    return next(error);
  }
}

async function getMe(req, res, next) {
  try {
    const user = await authService.getUserById(req.user.id);
    return res.status(200).json(successResponse({ user }, 'Current user retrieved successfully.'));
  } catch (error) {
    return next(error);
  }
}

async function logout(req, res) {
  return res.status(200).json(successResponse(null, 'Logout successful.'));
}

module.exports = {
  register,
  login,
  getMe,
  logout,
};
