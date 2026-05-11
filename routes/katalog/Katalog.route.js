const express = require('express');
const router = express.Router();
const katalogController = require('../../controllers/katalog/Katalog');
const { verifyToken } = require('../../middlewares/Auth.middleware'); 

router.post('/', verifyToken, katalogController.create);
router.get('/', katalogController.getAll);
router.put('/:id_katalog', verifyToken, katalogController.update);
router.delete('/:id_katalog', verifyToken, katalogController.delete);

module.exports = router;