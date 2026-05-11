const AuthService = require('../../service/auth/Auth.service');

const register = async (req, res) => {
    try {
        const data = await AuthService.authRegister(req.body);
        res.status(201).json({ message: 'Registrasi staff berhasil', data });
    } catch (error) {
        if (error.message === 'Email sudah terdaftar') return res.status(400).json({ message: error.message });
        console.error(error);
        res.status(500).json({ error: 'Terjadi kesalahan pada server' });
    }
};

