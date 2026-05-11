const express = require('express');
const cors = require('cors');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Route dasar
app.get('/', (req, res) => {
    res.json({ message: "Welcome to DriveEase API Backend" });
});

// Jalankan Server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server DriveEase berjalan di port ${PORT}`);
});