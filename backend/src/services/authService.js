const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const config = require('../config/env');
const userRepository = require('../repositories/userRepository');

function createError(message, statusCode = 400) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

function sanitizeUser(user) {
  if (!user) return null;

  return {
    id: user.id,
    name: user.name,
    email: user.email,
    phone: user.phone,
    role: user.role,
    profile_image_url: user.profile_image_url || null,
    is_active: user.is_active,
  };
}

function signToken(user) {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
    },
    config.jwtSecret,
    { expiresIn: config.jwtExpiresIn },
  );
}

async function registerUser({ name, email, password, phone }) {
  if (!name || !String(name).trim()) {
    throw createError('Name is required.', 400);
  }

  if (!email || !String(email).trim()) {
    throw createError('Email is required.', 400);
  }

  if (!password || String(password).length < 8) {
    throw createError('Password must be at least 8 characters long.', 400);
  }

  const normalizedEmail = String(email).trim().toLowerCase();
  const existingUser = await userRepository.findByEmail(normalizedEmail);
  if (existingUser) {
    throw createError('Email already registered.', 409);
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const createdUser = await userRepository.createUser({
    name: String(name).trim(),
    email: normalizedEmail,
    phone: phone || null,
    passwordHash,
    role: 'citizen',
  });

  const token = signToken(createdUser);

  return {
    user: sanitizeUser(createdUser),
    token,
  };
}

async function loginUser({ email, password }) {
  if (!email || !password) {
    throw createError('Email and password are required.', 400);
  }

  const normalizedEmail = String(email).trim().toLowerCase();
  const user = await userRepository.findByEmail(normalizedEmail);

  if (!user) {
    throw createError('Invalid email or password.', 401);
  }

  const isPasswordValid = await bcrypt.compare(password, user.password_hash);
  if (!isPasswordValid) {
    throw createError('Invalid email or password.', 401);
  }

  if (!user.is_active) {
    throw createError('User account is inactive.', 403);
  }

  const token = signToken(user);

  return {
    user: sanitizeUser(user),
    token,
  };
}

async function getUserById(id) {
  const user = await userRepository.findById(id);
  if (!user) {
    throw createError('User not found.', 404);
  }

  return sanitizeUser(user);
}

module.exports = {
  registerUser,
  loginUser,
  getUserById,
  sanitizeUser,
};
