const jwt = require('jsonwebtoken'); // Mengimpor pustaka JSON Web Token (JWT) untuk membuat dan memverifikasi token keamanan login

const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Akses ditolak! Token autentikasi tidak ditemukan.' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        req.user = decoded;
        
        next();
    } catch (error) {
        console.error('Error Verifikasi Token:', error.message);
        return res.status(403).json({ message: 'Akses ditolak! Token tidak valid atau sudah kedaluwarsa.' });
    }
};

module.exports = { verifyToken };