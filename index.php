<?php
// File: index.php
// Deskripsi: Halaman utama sistem e-lapor mahasiswa

// Mulai output buffering untuk mencegah 'headers already sent' error
ob_start();

// Mulai session
session_start();

// Konfigurasi dasar
define('BASE_PATH', __DIR__);
define('BASE_URL', 'http://localhost/tester/');

// Cek apakah user sudah login
$isLoggedIn = isset($_SESSION['user_id']);
$userRole = $isLoggedIn ? $_SESSION['role'] : '';

// Routing sederhana
$page = isset($_GET['page']) ? $_GET['page'] : 'home';

// Header
include_once 'includes/header.php';

// Konten
switch ($page) {
    case 'home':
        include_once 'pages/home.php';
        break;
    case 'login':
        include_once 'pages/login.php';
        break;
    case 'register':
        // Redirect ke halaman login karena register hanya bisa dilakukan oleh admin
        header('Location: ' . BASE_URL . '?page=login');
        exit;
        break;
    case 'dashboard':
        // Cek apakah user sudah login
        if (!$isLoggedIn) {
            header('Location: ' . BASE_URL . '?page=login');
            exit;
        }
        // Jika role admin, redirect ke halaman admin
        if ($userRole === 'admin') {
            header('Location: ' . BASE_URL . '?page=admin');
            exit;
        }
        include_once 'pages/dashboard.php';
        break;
    case 'laporan':
        // Cek apakah user sudah login
        if (!$isLoggedIn) {
            header('Location: ' . BASE_URL . '?page=login');
            exit;
        }
        include_once 'pages/laporan.php';
        break;
    case 'profile':
        // Cek apakah user sudah login
        if (!$isLoggedIn) {
            header('Location: ' . BASE_URL . '?page=login');
            exit;
        }
        include_once 'pages/profile.php';
        break;
    case 'admin':
        // Cek apakah user adalah admin
        if (!$isLoggedIn || $userRole !== 'admin') {
            header('Location: ' . BASE_URL . '?page=login');
            exit;
        }
        include_once 'pages/admin/index.php';
        break;
    case 'logout':
        include_once 'actions/logout.php';
        break;
    default:
        include_once 'pages/404.php';
        break;
}

// Footer
include_once 'includes/footer.php';

// Akhiri output buffering dan kirim output ke browser
ob_end_flush();