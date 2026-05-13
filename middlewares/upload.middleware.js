const multer = require('multer');
const path = require('path');

// Konfigurasi penyimpanan Multer
const konfigurasiPenyimpanan = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './public/uploads/'); // Pastikan folder public/uploads/ sudah ada
  },
  filename: function (req, file, cb) {
    const akhiranUnik = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, akhiranUnik + path.extname(file.originalname));
  }
});

const uploadGambar = multer({ storage: konfigurasiPenyimpanan });

const siapkanUrlGambar = (req, res, next) => {
  if (req.file) {
    req.urlGambar = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
  }
  next();
};

// Jika Database Gagal
const pembersihanOtomatisSaatError = (req, res, next) => {
  const jsonAsli = res.json;
  res.json = function (data) {
    // Jika controller mengirim status error (>=400) dan ada file yang baru masuk, hapus filenya
    if (res.statusCode >= 400 && req.file) {
      const jalurFile = path.join(__dirname, '../public/uploads', req.file.filename);
      if (fs.existsSync(jalurFile)) {
        fs.unlinkSync(jalurFile);
        console.log(`[Sistem] File sampah dihapus otomatis: ${req.file.filename}`);
      }
    }
    return jsonAsli.call(this, data);
  };
  next();
};

// Untuk Update/Delete)
const pasangHelperHapusFile = (req, res, next) => {
  res.hapusFileFisik = (url) => {
    if (!url) return;
    const namaFile = url.split('/').pop();
    const jalurFile = path.join(__dirname, '../public/uploads', namaFile);
    if (fs.existsSync(jalurFile)) {
      fs.unlinkSync(jalurFile);
      console.log(`[Sistem] File fisik berhasil dihapus: ${namaFile}`);
    }
  };
  next();
};

module.exports = {
  uploadGambar,
  siapkanUrlGambar,
  pembersihanOtomatisSaatError,
  pasangHelperHapusFile
};