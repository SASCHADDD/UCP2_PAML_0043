const db = require('../../config/db');

exports.tambahKatalog = async (data) => {
    const { nama_kendaraan, merk , tahun, plat_nomor,harga, status} = data;

    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE plat_nomor = ?',[plat_nomor]);
    if(ExistingCar.length>0){
        const error = new Error('Plat nomor sudah terdaftar di mobil!');
        error.statusCode = 400;
        throw error;
    }
}