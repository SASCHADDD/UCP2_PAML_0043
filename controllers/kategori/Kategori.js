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

exports.getAll = async (req, res) => {
    try {
        const result = await kategoriService.getKategori();
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Get Kategori:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.update = async (req, res) => {
    try {
        const { id_kategori } = req.params;
        const result = await kategoriService.updateKategori(id_kategori, req.body);
        
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Update Kategori:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.delete = async (req, res) => {
    try {
        const { id_kategori } = req.params;
        const result = await kategoriService.deleteKategori(id_kategori);
        
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Delete Kategori:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};