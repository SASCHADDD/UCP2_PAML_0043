const db = require('../../config/db');
const bcrypt = require('bcrypt');
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