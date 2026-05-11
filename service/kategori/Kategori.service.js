const db = require('../../config/db');

exports.tambahKategori = async (data) => {
    const { id_kategori, nama_kategori } = data;

    const [ExistingCategory] = await db.query('SELECT * FROM kategori WHERE nama_kategori = ?',[nama_kategori]);
    if(ExistingCategory.length>0){
        const error = new Error('Kategori sudah terdaftar!');
        error.statusCode = 400;
        throw error;
    }

    const [result] = await db.query(
        'INSERT INTO kategori (id_kategori, nama_kategori) VALUES (?, ?)',
        [id_kategori, nama_kategori]
    );
    return { 
        message: 'Data kategori berhasil ditambahkan!', 
        id_kategori: result.insertId 
    };
}