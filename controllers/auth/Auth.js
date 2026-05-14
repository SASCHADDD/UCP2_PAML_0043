const authService = require('../../service/auth/Auth.service');

exports.register = async (req, res) => {
    try {
        const { nama, email, password } = req.body;
        
        // Panggil logic dari service
        const result = await authService.registerUser(nama, email, password);
        
        res.status(201).json(result);
    } catch (error) {
        console.error('Error Register:', error);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        
        // Panggil logic dari service
        const result = await authService.loginUser(email, password);
        
        res.status(200).json(result);
    } catch (error) {
        console.error('Error Login:', error.message);
        const statusCode = error.statusCode || 500;
        res.status(statusCode).json({ message: error.message || 'Terjadi kesalahan pada server' });
    }
};

exports.logout = async (req, res) => {
    try {
        res.status(200).json({ message: 'Logout berhasil!' });
    } catch (error) {
        console.error('Error Logout:', error.message);
        res.status(500).json({ message: 'Terjadi kesalahan pada server' });
    }
};