const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/Auth');

// Endpoint: POST /api/auth/register
router.post('/register', authController.register);

// Endpoint: POST /api/auth/login
router.post('/login', authController.login);

router.post('/logout', authController.logout);

module.exports = router;