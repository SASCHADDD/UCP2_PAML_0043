const express = require('express');
const router = express.Router();

const katalogController = require('../../controllers/katalog/Katalog');
const { verifyToken } = require('../../middlewares/Auth.middleware'); 
const {uploadGambar,siapkanUrlGambar,pembersihanOtomatisSaatError,pasangHelperHapusFile} = require('../../middlewares/upload.middleware');


//katalog
router.get('/', katalogController.getAll);
router.delete('/:id_katalog', verifyToken, pasangHelperHapusFile, katalogController.delete);
router.post('/',verifyToken,uploadGambar.single('gambar'),siapkanUrlGambar,pembersihanOtomatisSaatError,pasangHelperHapusFile,katalogController.create);

router.put('/:id_katalog', 
  verifyToken, 
  uploadGambar.single('gambar'), 
  siapkanUrlGambar, 
  pembersihanOtomatisSaatError, 
  pasangHelperHapusFile, 
  katalogController.update
);
module.exports = router;