const express = require('express');
const router = express.Router();

const katalogController = require('../../controllers/katalog/Katalog');
const { verifyToken } = require('../../middlewares/Auth.middleware'); 
const db = require('../../config/db');

const uploadGambar = require('../../middlewares/upload.middleware');

// router.post('/', verifyToken, katalogController.create);
router.get('/', katalogController.getAll);
router.put('/:id_katalog', verifyToken, katalogController.update);
router.delete('/:id_katalog', verifyToken, katalogController.delete);
router.post('/', verifyToken, uploadGambar.single('gambar'), katalogController.create);
router.post('/', uploadGambar.single('gambar'), (req, res) => {
  // Tangkap teks dari body
  

  const query = `INSERT INTO katalog (id_kategori, nama_kendaraan, merk, tahun, plat_nomor, harga, status, gambar) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(query, [id_kategori, nama_kendaraan, merk, tahun, plat_nomor, harga, status, gambarUrl], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: 'Gagal menyimpan data ke database' });
    }
    
    res.status(201).json({ 
      message: 'Katalog berhasil ditambahkan',
      data: {
        id_katalog: results.insertId,
        gambar: gambarUrl
      }
    });
  });
});

module.exports = router;