const express = require('express');
const router = express.Router();
const { verifyToken } = require('../../middlewares/Auth.middleware');
const kategoriController = require('../../controllers/kategori/Kategori');

router.post('/', verifyToken, kategoriController.create);

module.exports = router;