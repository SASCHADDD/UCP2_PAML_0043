const db = require('../../config/db');

exports.tambahKatalog = async (data) => {
    const { id_kategori, nama_kendaraan, merk , tahun, plat_nomor,harga, status} = data;

    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE plat_nomor = ?',[plat_nomor]);
    if(ExistingCar.length>0){
        const error = new Error('Plat nomor sudah terdaftar di mobil!');
        error.statusCode = 400;
        throw error;
    }

    const [result] = await db.query(
        'INSERT INTO katalog (id_kategori, nama_kendaraan, merk, tahun, plat_nomor, harga) VALUES (?, ?, ?, ?, ?, ?)',
        [id_kategori, nama_kendaraan, merk, tahun, plat_nomor, harga]
    );
    return { 
        message: 'Data mobil berhasil ditambahkan!', 
        id_katalog: result.insertId 
    };
}

exports.getKatalog = async () => {
    const [rows] = await db.query('SELECT * FROM katalog');
    return rows;
}

exports.updateKatalog = async (id_katalog, data) => {
    const { id_kategori, nama_kendaraan, merk , tahun, plat_nomor,harga, status} = data;

    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE id_katalog = ?',[id_katalog]);
    if(ExistingCar.length === 0){
        const error = new Error('Mobil tidak ditemukan!');
        error.statusCode = 404;
        throw error;
    }

    await db.query(
        'UPDATE katalog SET id_kategori = ?, nama_kendaraan = ?, merk = ?, tahun = ?, plat_nomor = ?, harga = ? WHERE id_katalog = ?',
        [id_kategori, nama_kendaraan, merk, tahun, plat_nomor, harga, id_katalog]
    );
    return { message: 'Data mobil berhasil diperbarui!' };
}

exports.deleteKatalog = async (id_katalog) => {
    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE id_katalog = ?',[id_katalog]);
    if(ExistingCar.length === 0){
        const error = new Error('Mobil tidak ditemukan!');
        error.statusCode = 404;
        throw error;
    }

    await db.query('DELETE FROM katalog WHERE id_katalog = ?', [id_katalog]);
    return { message: 'Data mobil berhasil dihapus!' };
}