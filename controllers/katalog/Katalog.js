const katalogService = require('../../service/katalog/Katalog.service');

exports.create = async (req, res) => {
    try {
        const result = await katalogService.tambahKatalog({
            ...req.body,
            gambar: req.urlGambar
        });
        res.status(201).json(result);
    } catch (error) {
        res.status(error.statusCode || 500).json({ message: error.message });
    }
};

exports.getAll = async (req, res) => {
    try {
        const result = await katalogService.getKatalog();
        res.status(200).json(result);
    } catch (error) {
        res.status(error.statusCode || 500).json({ message: error.message });
    }
};

exports.update = async (req, res) => {
    try {
        const { id_katalog } = req.params;
        const mobilLama = await katalogService.getKatalogById(id_katalog);
        
        if (!mobilLama) return res.status(404).json({ message: 'Mobil tidak ditemukan' });

        // Siapkan data yang akan dikirim ke Service
        const dataUpdate = { ...req.body, gambar: mobilLama.gambar };

        // Jika user upload gambar baru, ganti URL-nya dan suruh helper hapus yang lama
        if (req.file) {
            dataUpdate.gambar = req.urlGambar;
            res.hapusFileFisik(mobilLama.gambar);
        }
        const result = await katalogService.updateKatalog(id_katalog, dataUpdate);
        res.status(200).json(result);

    } catch (error) {
        res.status(error.statusCode || 500).json({ message: error.message });
    }
};

exports.delete = async (req, res) => {
    try {
        const { id_katalog } = req.params;

        // 1. Ambil data lama untuk mengetahui URL gambar yang harus dihapus
        const mobil = await katalogService.getKatalogById(id_katalog);
        if (!mobil) {
            return res.status(404).json({ message: 'Data mobil tidak ditemukan' });
        }

        // 2. Hapus baris data di MySQL melalui Service
        await katalogService.deleteKatalog(id_katalog);

        // 3. Jika berhasil dihapus dari database, bersihkan file fisik di MacBook-mu
        res.hapusFileFisik(mobil.gambar);
        
        res.status(200).json({ 
            message: 'Data mobil beserta file gambar berhasil dihapus secara permanen' 
        });
    } catch (error) {
        res.status(error.statusCode || 500).json({ message: error.message });
    }
};