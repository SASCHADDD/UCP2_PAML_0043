const db = require('../../config/db');

exports.tambahKategori = async (data) => {
    const { id_kategori, nama_kategori } = data;

    const [ExistingCategory] = await db.query('SELECT * FROM kategori WHERE nama_kategori = ?', [nama_kategori]);
    if (ExistingCategory.length > 0) {
        const error = new Error('Kategori sudah terdaftar!');
        error.statusCode = 400;
        throw error;
    }

    const [result] = await db.query(
        'INSERT INTO kategori (nama_kategori) VALUES (?)',
        [nama_kategori]
    );
    return {
        message: 'Data kategori berhasil ditambahkan!',
        id_kategori: result.insertId
    };
}

exports.getKategori = async () => {
    const [rows] = await db.query('SELECT * FROM kategori');
    return rows;
}

exports.updateKategori = async (id_kategori, data) => {
    const { nama_kategori } = data;

    const [ExistingCategory] = await db.query('SELECT * FROM kategori WHERE id_kategori = ?', [id_kategori]);
    if (ExistingCategory.length === 0) {
        const error = new Error('Kategori tidak ditemukan!');
        error.statusCode = 404;
        throw error;
    }

    await db.query(
        'UPDATE kategori SET nama_kategori = ? WHERE id_kategori = ?',
        [nama_kategori, id_kategori]
    );
    return { message: 'Data kategori berhasil diperbarui!' };
}

exports.deleteKategori = async (id_kategori) => {
    const [ExistingCategory] = await db.query('SELECT * FROM kategori WHERE id_kategori = ?', [id_kategori]);
    if (ExistingCategory.length === 0) {
        const error = new Error('Kategori tidak ditemukan!');
        error.statusCode = 404;
        throw error;
    }

    await db.query('DELETE FROM kategori WHERE id_kategori = ?', [id_kategori]);
    return { message: 'Data kategori berhasil dihapus!' };
}