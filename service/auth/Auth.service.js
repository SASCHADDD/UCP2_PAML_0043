const db = require('../../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.registerUser = async (nama, email, password) => {
    // 1. Cek apakah email sudah dipakai
    const [existingUser] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
        const error = new Error('Email sudah terdaftar!');
        error.statusCode = 400;
        throw error;
    }

    // 2. Enkripsi password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 3. Simpan ke database
    await db.query(
        'INSERT INTO users (nama, email, password) VALUES (?, ?, ?)',
        [nama, email, hashedPassword]
    );

    return { message: 'Registrasi berhasil! Silakan login.' };
};

// Logic untuk Login
exports.loginUser = async (email, password) => {
    // 1. Cari user di database
    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
        const error = new Error('Email tidak ditemukan!');
        error.statusCode = 404;
        throw error;
    }

    const user = users[0];

    // 2. Cocokkan password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        const error = new Error('Password salah!');
        error.statusCode = 401;
        throw error;
    }

    // 3. Buat JWT Token
    const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: '1d' }
    );

    return {
        message: 'Login berhasil!',
        token: token,
        user: {
            id: user.id,
            nama: user.nama,
            email: user.email
        }
    };
};