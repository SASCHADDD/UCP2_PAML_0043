const db = require('../../config/db');

exports.tambahKatalog = async (data) => {
    const { nama_kendaraan, merk , tahun, plat_nomor,harga, status} = data;

    const [ExistingCar] = await db.query('SELECT * FROM katalog WHERE plat_nomor = ?',)
}