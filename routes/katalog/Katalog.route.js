const express = require('express');
const router = express.Router();

const katalogController = require('../../controllers/katalog/Katalog');
const { verifyToken } = require('../../middlewares/Auth.middleware'); 
const {ploadGambar,siapkanUrlGambar,pembersihanOtomatisSaatError,pasangHelperHapusFile} = require('../../middlewares/upload.middleware');

router.get('/', katalogController.getAll);
router.put('/:id_katalog', verifyToken, katalogController.update);
router.delete('/:id_katalog', verifyToken, katalogController.delete);
router.post('/',verifyToken,uploadGambar.single('gambar'),siapkanUrlGambar,pembersihanOtomatisSaatError,pasangHelperHapusFile,katalogController.create);

module.exports = router;