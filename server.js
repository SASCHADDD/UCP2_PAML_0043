const express = require('express');
const cors = require('cors');

const app = express();
const authRoutes = require('./routes/auth/Auth.route');
const katalogRoutes = require('./routes/katalog/Katalog.route'); 
const kategoriRoutes = require('./routes/kategori/Kategori.route');
// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


// Menghubungkan prefix '/api/auth' dengan authRoutes
app.use('/api/auth', authRoutes);
app.use('/api/katalog', katalogRoutes); 
app.use('/api/kategori', kategoriRoutes);
// Route dasar
app.get('/', (req, res) => {
    res.json({ message: "Welcome to DriveEase API Backend" });
});

// Jalankan Server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server DriveEase berjalan di port ${PORT}`);
});