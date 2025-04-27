-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 27, 2025 at 10:33 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `elapor_mahasiswa`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` text,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fakultas`
--

CREATE TABLE `fakultas` (
  `id` int NOT NULL,
  `nama_fakultas` varchar(100) NOT NULL,
  `kode_fakultas` varchar(10) NOT NULL,
  `deskripsi` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fakultas`
--

INSERT INTO `fakultas` (`id`, `nama_fakultas`, `kode_fakultas`, `deskripsi`, `created_at`) VALUES
(1, 'Ekonomi Dan Bisnis', 'EKBIS', NULL, '2025-04-20 10:04:32'),
(2, 'Teknologi Informasi', 'TI', NULL, '2025-04-20 10:04:32'),
(3, 'Peternakan', 'PT', NULL, '2025-04-20 10:04:32'),
(4, 'Perkebunan', 'PK', NULL, '2025-04-20 10:04:32'),
(5, 'Pertanian', 'PR', NULL, '2025-04-20 10:04:32');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_laporan`
--

CREATE TABLE `kategori_laporan` (
  `id` int NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `deskripsi` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategori_laporan`
--

INSERT INTO `kategori_laporan` (`id`, `nama_kategori`, `icon`, `deskripsi`, `created_at`) VALUES
(1, 'Akademik', 'book', 'Laporan terkait masalah akademik seperti nilai, jadwal kuliah, dll', '2025-04-20 09:58:25'),
(2, 'Fasilitas', 'building', 'Laporan terkait fasilitas kampus seperti ruang kelas, laboratorium, dll', '2025-04-20 09:58:25'),
(3, 'Administrasi', 'file-alt', 'Laporan terkait masalah administrasi seperti pendaftaran, pembayaran, dll', '2025-04-20 09:58:25'),
(4, 'Layanan IT', 'laptop', 'Laporan terkait masalah layanan IT seperti wifi, sistem informasi, dll', '2025-04-20 09:58:25'),
(5, 'Lainnya', 'question-circle', 'Laporan yang tidak termasuk dalam kategori yang tersedia', '2025-04-20 09:58:25');

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `kategori_id` int NOT NULL,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `lampiran` varchar(255) DEFAULT NULL,
  `prioritas` enum('rendah','sedang','tinggi') DEFAULT 'rendah',
  `status` enum('pending','processing','completed','rejected') DEFAULT 'pending',
  `is_anonymous` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `closed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `laporan`
--

INSERT INTO `laporan` (`id`, `user_id`, `kategori_id`, `judul`, `deskripsi`, `lampiran`, `prioritas`, `status`, `is_anonymous`, `created_at`, `updated_at`, `closed_at`) VALUES
(2, 2, 1, 'Test Laporan Manual', 'Ini adalah laporan test yang dibuat secara manual', NULL, 'tinggi', 'rejected', 0, '2025-04-21 05:54:57', '2025-04-21 06:07:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `prodi_id` int NOT NULL,
  `nim` varchar(20) NOT NULL,
  `alamat` text,
  `no_telp` varchar(15) DEFAULT NULL,
  `tahun_masuk` year DEFAULT NULL,
  `status` enum('aktif','cuti','lulus','drop out') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`id`, `user_id`, `prodi_id`, `nim`, `alamat`, `no_telp`, `tahun_masuk`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, '2023001', 'Jl. Contoh Alamat No. 123', '081234567890', 2023, 'aktif', '2025-04-20 10:04:32', '2025-04-20 10:04:32');

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `judul` varchar(100) NOT NULL,
  `pesan` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifikasi`
--

INSERT INTO `notifikasi` (`id`, `user_id`, `judul`, `pesan`, `link`, `is_read`, `created_at`) VALUES
(1, 2, 'Status Laporan Diperbarui', 'Status laporan \"Jalan Rusak di depan kampus\" telah diperbarui menjadi completed', '?page=laporan&action=view&id=1', 1, '2025-04-20 14:18:24'),
(2, 2, 'Tanggapan Baru', 'Ada tanggapan baru pada laporan \"Jalan Rusak di depan kampus\"', '?page=laporan&action=view&id=1', 1, '2025-04-20 14:18:24'),
(3, 1, 'Laporan baru: Test Laporan Manual', 'Ada laporan baru yang perlu ditinjau.', '?page=admin&action=view_laporan&id=2', 1, '2025-04-21 05:54:57'),
(4, 1, 'TEST: Laporan baru dari Debug', 'TEST: Ada laporan baru yang perlu ditinjau.', '?page=admin&action=view_laporan&id=2', 1, '2025-04-21 05:54:57'),
(5, 2, 'Status Laporan Diperbarui', 'Status laporan \"Test Laporan Manual\" telah diperbarui menjadi rejected', '?page=laporan&action=view&id=2', 1, '2025-04-21 06:07:34'),
(6, 2, 'Tanggapan Baru', 'Ada tanggapan baru pada laporan \"Test Laporan Manual\"', '?page=laporan&action=view&id=2', 0, '2025-04-21 06:07:34'),
(7, 1, 'Tanggapan Baru', 'Ada tanggapan baru pada laporan \"Test Laporan Manual\"', '?page=laporan&action=view&id=2', 1, '2025-04-21 06:08:46');

-- --------------------------------------------------------

--
-- Table structure for table `prodi`
--

CREATE TABLE `prodi` (
  `id` int NOT NULL,
  `fakultas_id` int NOT NULL,
  `nama_prodi` varchar(100) NOT NULL,
  `kode_prodi` varchar(10) NOT NULL,
  `jenjang` enum('D3','D4','S1','S2','S3') NOT NULL,
  `deskripsi` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `prodi`
--

INSERT INTO `prodi` (`id`, `fakultas_id`, `nama_prodi`, `kode_prodi`, `jenjang`, `deskripsi`, `created_at`) VALUES
(1, 2, 'Teknologi Rekayasa Perangkat Lunak', 'TRPL', 'D3', NULL, '2025-04-20 10:04:32'),
(2, 1, 'Akuntansi Perpajakan', 'AP', 'D3', NULL, '2025-04-20 10:04:32'),
(3, 2, 'Teknologi Rekayasa Internet', 'TRI', 'D3', NULL, '2025-04-20 10:04:32'),
(4, 2, 'Manajemen Informatika', 'MI', 'D3', NULL, '2025-04-20 10:04:32'),
(5, 2, 'Teknologi Rekayasa Elektronika', 'TRE', 'D3', NULL, '2025-04-20 10:04:32'),
(6, 1, 'Akutansi Bisnis Digital', 'ABD', 'D3', NULL, '2025-04-20 10:04:32'),
(7, 3, 'Perhotelan', 'PH', 'D3', NULL, '2025-04-20 10:04:32'),
(8, 4, 'Agribisnis', 'AG', 'D3', NULL, '2025-04-20 10:04:32'),
(9, 5, 'Teknologi Pangan', 'TEPA', 'D3', NULL, '2025-04-20 10:04:32');

-- --------------------------------------------------------

--
-- Table structure for table `tanggapan`
--

CREATE TABLE `tanggapan` (
  `id` int NOT NULL,
  `laporan_id` int NOT NULL,
  `user_id` int NOT NULL,
  `tanggapan` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tanggapan`
--

INSERT INTO `tanggapan` (`id`, `laporan_id`, `user_id`, `tanggapan`, `created_at`) VALUES
(2, 2, 1, 'sdzs', '2025-04-21 06:07:34'),
(3, 2, 2, 'baiklah', '2025-04-21 06:08:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `nim` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','mahasiswa') NOT NULL DEFAULT 'mahasiswa',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama_lengkap`, `nim`, `email`, `username`, `password`, `role`, `created_at`, `updated_at`, `active`) VALUES
(1, 'Administrator', NULL, 'admin@example.com', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', '2025-04-20 09:58:25', '2025-04-20 09:58:25', 1),
(2, 'Angga Ramadhan', '23759005', 'anggarm@example.com', 'anggarm', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'mahasiswa', '2025-04-20 10:00:24', '2025-04-20 10:00:24', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `fakultas`
--
ALTER TABLE `fakultas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kategori_laporan`
--
ALTER TABLE `kategori_laporan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `kategori_id` (`kategori_id`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `prodi_id` (`prodi_id`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `prodi`
--
ALTER TABLE `prodi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fakultas_id` (`fakultas_id`);

--
-- Indexes for table `tanggapan`
--
ALTER TABLE `tanggapan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `laporan_id` (`laporan_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `nim` (`nim`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fakultas`
--
ALTER TABLE `fakultas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kategori_laporan`
--
ALTER TABLE `kategori_laporan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `prodi`
--
ALTER TABLE `prodi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tanggapan`
--
ALTER TABLE `tanggapan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `laporan`
--
ALTER TABLE `laporan`
  ADD CONSTRAINT `laporan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `laporan_ibfk_2` FOREIGN KEY (`kategori_id`) REFERENCES `kategori_laporan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `mahasiswa_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mahasiswa_ibfk_2` FOREIGN KEY (`prodi_id`) REFERENCES `prodi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `notifikasi_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `prodi`
--
ALTER TABLE `prodi`
  ADD CONSTRAINT `prodi_ibfk_1` FOREIGN KEY (`fakultas_id`) REFERENCES `fakultas` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tanggapan`
--
ALTER TABLE `tanggapan`
  ADD CONSTRAINT `tanggapan_ibfk_1` FOREIGN KEY (`laporan_id`) REFERENCES `laporan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tanggapan_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
