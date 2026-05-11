const katalogService = require('../../service/katalog/Katalog.service');

exports.create = async (req, res) => {
    try {
        // req.user berisi data dari JWT (karena sudah lolos middleware nanti)
        const result = await katalogService.tambahKatalog(req.body);
        
        res.status(201).json(result);
    } catch (error) {
        console.error('Error Create Katalog:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.getAll = async (req, res) => {
    try {
        const result = await katalogService.getKatalog();
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Get Katalog:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.update = async (req, res) => {
    try {
        const { id_katalog } = req.params;
        const result = await katalogService.updateKatalog(id_katalog, req.body);
        
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Update Katalog:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.delete = async (req, res) => {
    try {
        const { id_katalog } = req.params;
        const result = await katalogService.deleteKatalog(id_katalog);
        
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Delete Katalog:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};