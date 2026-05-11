const kategoriService = require('../../service/kategori/Kategori.service');

exports.create = async (req, res) => {
    try {
        // req.user berisi data dari JWT (karena sudah lolos middleware nanti)
        const result = await kategoriService.tambahKategori(req.body);
        
        res.status(201).json(result);
    } catch (error) {
        console.error('Error Create Kategori:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};