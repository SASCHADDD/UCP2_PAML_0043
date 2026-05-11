const express = require('express');
const router = express.Router();
const katalogController = require('../../controllers/katalog/Katalog');
const { verifyToken } = require('../../middlewares/Auth.middleware'); 

router.post('/', verifyToken, katalogController.create);

module.exports = router;