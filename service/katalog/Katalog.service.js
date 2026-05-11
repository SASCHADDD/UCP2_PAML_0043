const db = require('../../config/db');

exports.tambahKatalog = async (data) => {
    const { nama_kendaraan, merk , tahun, plat_nomor,harga, status} = data;

    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE plat_nomor = ?',[plat_nomor]);
    if(ExistingCar.length>0){
        const error = new Error('Plat nomor sudah terdaftar di mobil!');
        error.statusCode = 400;
        throw error;
    }

    const [result] = await db.query(
        'INSERT INTO katalog (kategori_id, nama_kendaraan, merk, tahun, plat_nomor, harga) VALUES (?, ?, ?, ?, ?, ?)',
        [kategori_id, nama_kendaraan, merk, tahun, plat_nomor, harga]
    );
    return { 
        message: 'Data armada berhasil ditambahkan!', 
        katalog_id: result.insertId 
    };
}