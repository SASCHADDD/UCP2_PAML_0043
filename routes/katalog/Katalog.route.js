const express = require('express');
const router = express.Router();
const katalogController = require('../../controllers/katalog/Katalog');

// Pastikan path folder middleware ini sesuai dengan yang kamu buat (middleware atau middlewares)
const { verifyToken } = require('../../middlewares/authMiddleware'); 

// Endpoint: POST /api/katalog -> Wajib bawa Token!
router.post('/', verifyToken, katalogController.create);

module.exports = router;