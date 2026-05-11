const express = require('express');
const router = express.Router();
const { verifyToken } = require('../../middlewares/Auth.middleware');
const kategoriController = require('../../controllers/kategori/Kategori');

router.post('/', verifyToken, kategoriController.create);
router.get('/', kategoriController.getAll);
router.put('/:id_kategori', verifyToken, kategoriController.update);
router.delete('/:id_kategori', verifyToken, kategoriController.delete);

module.exports = router;