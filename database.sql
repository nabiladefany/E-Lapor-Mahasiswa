-- Database untuk Sistem E-Lapor Mahasiswa

-- Membuat database
CREATE DATABASE IF NOT EXISTS elapor_mahasiswa;
USE elapor_mahasiswa;

-- Tabel pengguna (users)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(100) NOT NULL,
    nim VARCHAR(20) DEFAULT NULL,
    role ENUM('admin', 'mahasiswa') NOT NULL DEFAULT 'mahasiswa',
    profile_pic VARCHAR(255) DEFAULT 'default.jpg',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_role (role),
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Tabel fakultas
CREATE TABLE IF NOT EXISTS fakultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_fakultas VARCHAR(100) NOT NULL,
    kode_fakultas VARCHAR(10) NOT NULL UNIQUE
);

-- Tabel program studi
CREATE TABLE IF NOT EXISTS prodi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fakultas_id INT NOT NULL,
    nama_prodi VARCHAR(100) NOT NULL,
    kode_prodi VARCHAR(10) NOT NULL UNIQUE,
    FOREIGN KEY (fakultas_id) REFERENCES fakultas(id) ON DELETE CASCADE
);

-- Tabel mahasiswa (detail tambahan untuk user dengan role mahasiswa)
CREATE TABLE IF NOT EXISTS mahasiswa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    prodi_id INT NOT NULL,
    semester INT NOT NULL,
    tahun_masuk YEAR NOT NULL,
    status ENUM('aktif', 'cuti', 'lulus', 'drop out') NOT NULL DEFAULT 'aktif',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (prodi_id) REFERENCES prodi(id) ON DELETE CASCADE
);

-- Tabel kategori laporan
CREATE TABLE IF NOT EXISTS kategori_laporan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    icon VARCHAR(50) DEFAULT 'file-alt'
);

-- Tabel laporan
CREATE TABLE IF NOT EXISTS laporan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    kategori_id INT NOT NULL,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT NOT NULL,
    lampiran VARCHAR(255) DEFAULT NULL,
    status ENUM('menunggu', 'diproses', 'selesai', 'ditolak') NOT NULL DEFAULT 'menunggu',
    prioritas ENUM('rendah', 'sedang', 'tinggi') NOT NULL DEFAULT 'sedang',
    is_anonymous BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (kategori_id) REFERENCES kategori_laporan(id) ON DELETE CASCADE,
    INDEX idx_status (status),
    INDEX idx_prioritas (prioritas),
    INDEX idx_created_at (created_at),
    INDEX idx_user_id (user_id),
    INDEX idx_kategori_id (kategori_id)
);

-- Tabel tanggapan
CREATE TABLE IF NOT EXISTS tanggapan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    laporan_id INT NOT NULL,
    user_id INT NOT NULL,
    tanggapan TEXT NOT NULL,
    lampiran VARCHAR(255) DEFAULT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (laporan_id) REFERENCES laporan(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_laporan_id (laporan_id),
    INDEX idx_created_at (created_at),
    INDEX idx_user_id (user_id)
);

-- Tabel notifikasi
CREATE TABLE IF NOT EXISTS notifikasi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    judul VARCHAR(100) NOT NULL,
    pesan TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    link VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);

-- Tabel log aktivitas
CREATE TABLE IF NOT EXISTS log_aktivitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    aktivitas VARCHAR(255) NOT NULL,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
);

-- Data awal untuk tabel fakultas
INSERT INTO fakultas (nama_fakultas, kode_fakultas) VALUES
('Ekonomi Dan Bisnis', 'EKBIS'),
('Teknologi Informasi', 'TI'),
('Peternakan', 'PT'),
('Perkebunan', 'PK'),
('Pertanian', 'PR');

-- Data awal untuk tabel program studi
INSERT INTO prodi (fakultas_id, nama_prodi, kode_prodi) VALUES
(2, 'Teknologi Rekayasa Perangkat Lunak', 'TRPL'),
(1, 'Akuntansi Perpajakan', 'AP'),
(2, 'Teknologi Rekayasa Internet', 'TRI'),
(2, 'Manajemen Informatika', 'MI'),
(2, 'Teknologi Rekayasa Elektronika', 'TRE'),
(1, 'Akutansi Bisnis Digital', 'ABD'),
(3, 'Perhotelan', 'PH'),
(4, 'Agribisnis', 'AG'),
(5, 'Teknologi Pangan', 'TEPA');

-- Data awal untuk tabel kategori laporan
INSERT INTO kategori_laporan (nama_kategori, deskripsi, icon) VALUES
('Akademik', 'Laporan terkait masalah akademik seperti nilai, jadwal kuliah, dll.', 'graduation-cap'),
('Fasilitas', 'Laporan terkait fasilitas kampus seperti ruang kelas, laboratorium, dll.', 'building'),
('Keuangan', 'Laporan terkait masalah keuangan seperti pembayaran SPP, beasiswa, dll.', 'money-bill'),
('Administrasi', 'Laporan terkait masalah administrasi seperti surat keterangan, transkrip, dll.', 'file-alt'),
('Layanan IT', 'Laporan terkait masalah layanan IT seperti email kampus, sistem informasi, dll.', 'laptop-code'),
('Lainnya', 'Laporan terkait masalah lain yang tidak termasuk dalam kategori di atas.', 'question-circle');

-- Membuat user admin default
INSERT INTO users (username, password, email, nama_lengkap, role) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@example.com', 'Administrator', 'admin');
-- Password: password

-- Membuat beberapa user mahasiswa
INSERT INTO users (username, password, email, nama_lengkap, nim, role) VALUES
('budi', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'budi@example.com', 'Budi Santoso', '2023001', 'mahasiswa'),
('ani', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ani@example.com', 'Ani Wijaya', '2023002', 'mahasiswa'),
('deni', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'deni@example.com', 'Deni Kurniawan', '2023003', 'mahasiswa');
-- Password untuk semua user: password

-- Menambahkan data mahasiswa
INSERT INTO mahasiswa (user_id, prodi_id, semester, tahun_masuk, status) VALUES
(2, 1, 3, 2022, 'aktif'),
(3, 3, 1, 2023, 'aktif'),
(4, 5, 5, 2021, 'aktif');