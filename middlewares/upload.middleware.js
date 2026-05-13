const multer = require('multer');
const path = require('path');

// Konfigurasi penyimpanan Multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './public/uploads/'); // Pastikan folder public/uploads/ sudah ada
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const uploadGambar = multer({ storage: storage });

const hapusFileFisik = (req, res, next) => {

  if (req.file) {
    req.fileUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
  } else {
    req.fileUrl = null;
  }
  
  res.hapusFile = (gambarUrl) => {
    if (gambarUrl) {
      // Mengambil nama file dari URL (misal: http://localhost:3000/uploads/file.jpg -> file.jpg)
      const namaFile = gambarUrl.split('/').pop();
      const pathFile = path.join(__dirname, '../public/uploads', namaFile);
      
      if (fs.existsSync(pathFile)) {
        fs.unlink(pathFile, (err) => {
          if (err) console.error("Gagal menghapus file:", err);
        });
      }
    }
  };
  next();
};

module.exports = uploadGambar;