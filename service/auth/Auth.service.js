const db = require('../../config/database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const authRegister = async (data) => {
    const { nama, email, password } = data;

    const [existingUser] = await db.execute('SELECT id FROM pengguna WHERE email = ?', [email]);
    if (existingUser.length > 0) throw new Error('Email sudah terdaftar');

    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await db.execute(
        `INSERT INTO pengguna (nama, email, password) VALUES (?, ?, ?)`,
        [nama, email, hashedPassword]
    );

    return { id: result.insertId, nama, email, password: hashedPassword };
};