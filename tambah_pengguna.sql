-- File: tambah_pengguna.sql
-- Deskripsi: Script untuk menambahkan pengguna baru ke database

-- Pastikan menggunakan database yang benar
USE elapor_mahasiswa;

-- Menambahkan pengguna baru (mahasiswa)
-- Password: password123 (sudah di-hash dengan bcrypt)
INSERT INTO users (username, password, email, nama_lengkap, nim, role) VALUES
('mahasiswa1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'mahasiswa1@example.com', 'Mahasiswa Satu', '2023004', 'mahasiswa'),
('mahasiswa2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'mahasiswa2@example.com', 'Mahasiswa Dua', '2023005', 'mahasiswa');
-- Password untuk semua user: password

-- Mendapatkan ID pengguna yang baru ditambahkan
SET @user_id1 = LAST_INSERT_ID();
SET @user_id2 = @user_id1 + 1;

-- Menambahkan data mahasiswa untuk pengguna baru
INSERT INTO mahasiswa (user_id, prodi_id, semester, tahun_masuk, status) VALUES
(@user_id1, 2, 2, 2023, 'aktif'),
(@user_id2, 4, 1, 2023, 'aktif');

-- Cara menggunakan file ini:
-- 1. Buka phpMyAdmin atau MySQL CLI
-- 2. Pilih database elapor_mahasiswa
-- 3. Import file ini atau jalankan query di atas
-- 4. Pengguna baru akan ditambahkan dengan password: password