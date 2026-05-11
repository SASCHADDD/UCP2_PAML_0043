const jwt = require('jsonwebtoken'); // Mengimpor pustaka JSON Web Token (JWT) untuk membuat dan memverifikasi token keamanan login

const verifyToken = (req, res, next) => {
    // 1. Ambil header Authorization dari request
    const authHeader = req.headers['authorization'];
    
    // 2. Format standar token adalah "Bearer <token>", jadi kita pisahkan string-nya
    const token = authHeader && authHeader.split(' ')[1];

    // 3. Jika token tidak ada sama sekali
    if (!token) {
        return res.status(401).json({ message: 'Akses ditolak! Token autentikasi tidak ditemukan.' });
    }

    try {
        // 4. Verifikasi token menggunakan Secret Key
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        // 5. Simpan data user yang ada di dalam token ke object req
        // Agar controller selanjutnya tahu siapa user yang sedang mengakses
        req.user = decoded;
        
        // 6. Lanjut ke controller/proses berikutnya
        next();
    } catch (error) {
        console.error('Error Verifikasi Token:', error.message);
        return res.status(403).json({ message: 'Akses ditolak! Token tidak valid atau sudah kedaluwarsa.' });
    }
};

module.exports = { verifyToken };