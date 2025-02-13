const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./auth.routes');
const userRoutes = require('./user.routes');

// Use routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);

module.exports = router; 