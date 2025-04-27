<?php
// File: tambah_pengguna.php
// Deskripsi: Script untuk menambahkan pengguna baru ke database melalui browser

// Koneksi ke database
require_once 'config/database.php';
$database = new Database();
$conn = $database->getConnection();

// Cek apakah koneksi berhasil
if ($conn === null) {
    die('Gagal terhubung ke database. Silakan coba lagi nanti atau hubungi administrator.');
}

// Inisialisasi variabel
$message = '';
$success = false;

// Cek apakah form telah disubmit
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ambil data dari form
    $username = trim($_POST['username']);
    $password = $_POST['password'];
    $email = trim($_POST['email']);
    $nama_lengkap = trim($_POST['nama_lengkap']);
    $nim = trim($_POST['nim']);
    $role = $_POST['role'];
    $prodi_id = isset($_POST['prodi_id']) ? $_POST['prodi_id'] : null;
    $semester = isset($_POST['semester']) ? $_POST['semester'] : null;
    $tahun_masuk = isset($_POST['tahun_masuk']) ? $_POST['tahun_masuk'] : null;
    
    // Validasi input
    if (empty($username) || empty($password) || empty($email) || empty($nama_lengkap)) {
        $message = 'Semua field wajib diisi';
    } else {
        try {
            // Mulai transaksi
            $conn->beginTransaction();
            
            // Hash password
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            
            // Tambahkan user baru
            $query = "INSERT INTO users (username, password, email, nama_lengkap, nim, role) 
                      VALUES (:username, :password, :email, :nama_lengkap, :nim, :role)";
            $stmt = $conn->prepare($query);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':password', $hashed_password);
            $stmt->bindParam(':email', $email);
            $stmt->bindParam(':nama_lengkap', $nama_lengkap);
            $stmt->bindParam(':nim', $nim);
            $stmt->bindParam(':role', $role);
            $stmt->execute();
            
            // Ambil ID user yang baru dibuat
            $user_id = $conn->lastInsertId();
            
            // Jika role adalah mahasiswa, tambahkan data mahasiswa
            if ($role === 'mahasiswa' && $prodi_id && $semester && $tahun_masuk) {
                $query = "INSERT INTO mahasiswa (user_id, prodi_id, semester, tahun_masuk, status) 
                          VALUES (:user_id, :prodi_id, :semester, :tahun_masuk, 'aktif')";
                $stmt = $conn->prepare($query);
                $stmt->bindParam(':user_id', $user_id);
                $stmt->bindParam(':prodi_id', $prodi_id);
                $stmt->bindParam(':semester', $semester);
                $stmt->bindParam(':tahun_masuk', $tahun_masuk);
                $stmt->execute();
            }
            
            // Commit transaksi
            $conn->commit();
            
            $success = true;
            $message = 'Pengguna baru berhasil ditambahkan';
        } catch (PDOException $e) {
            // Rollback transaksi jika terjadi error
            $conn->rollBack();
            $message = 'Terjadi kesalahan: ' . $e->getMessage();
        }
    }
}

// Ambil data prodi untuk dropdown
$query = "SELECT p.id, p.nama_prodi, f.nama_fakultas 
          FROM prodi p 
          JOIN fakultas f ON p.fakultas_id = f.id 
          ORDER BY f.nama_fakultas, p.nama_prodi";
$stmt = $conn->prepare($query);
$stmt->execute();
$prodi_list = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Pengguna Baru - E-Lapor Mahasiswa</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-lg">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i> Tambah Pengguna Baru</h4>
                    </div>
                    <div class="card-body p-4">
                        <?php if (!empty($message)): ?>
                            <div class="alert alert-<?php echo $success ? 'success' : 'danger'; ?> alert-dismissible fade show" role="alert">
                                <?php echo $message; ?>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <?php endif; ?>
                        
                        <form method="post" action="">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="nama_lengkap" class="form-label">Nama Lengkap <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="nama_lengkap" name="nama_lengkap" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="nim" class="form-label">NIM</label>
                                    <input type="text" class="form-control" id="nim" name="nim">
                                </div>
                                <div class="col-md-6">
                                    <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="mahasiswa">Mahasiswa</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div id="mahasiswa-details">
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <label for="prodi_id" class="form-label">Program Studi</label>
                                        <select class="form-select" id="prodi_id" name="prodi_id">
                                            <option value="">Pilih Program Studi</option>
                                            <?php foreach ($prodi_list as $prodi): ?>
                                                <option value="<?php echo $prodi['id']; ?>">
                                                    <?php echo $prodi['nama_prodi'] . ' - ' . $prodi['nama_fakultas']; ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="semester" class="form-label">Semester</label>
                                        <select class="form-select" id="semester" name="semester">
                                            <option value="">Pilih Semester</option>
                                            <?php for ($i = 1; $i <= 8; $i++): ?>
                                                <option value="<?php echo $i; ?>"><?php echo $i; ?></option>
                                            <?php endfor; ?>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="tahun_masuk" class="form-label">Tahun Masuk</label>
                                        <select class="form-select" id="tahun_masuk" name="tahun_masuk">
                                            <option value="">Pilih Tahun Masuk</option>
                                            <?php for ($year = date('Y'); $year >= date('Y') - 5; $year--): ?>
                                                <option value="<?php echo $year; ?>"><?php echo $year; ?></option>
                                            <?php endfor; ?>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                <a href="index.php" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-arrow-left me-1"></i> Kembali
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i> Simpan
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="card border-0 shadow-lg mt-4">
                    <div class="card-header bg-info text-white text-center py-3">
                        <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i> Informasi</h4>
                    </div>
                    <div class="card-body p-4">
                        <p>Berikut adalah pengguna yang sudah ada di database:</p>
                        <ul>
                            <li><strong>Admin:</strong> username: admin, password: password</li>
                            <li><strong>Mahasiswa:</strong> username: budi, password: password</li>
                            <li><strong>Mahasiswa:</strong> username: ani, password: password</li>
                            <li><strong>Mahasiswa:</strong> username: deni, password: password</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle mahasiswa details based on role selection
        document.getElementById('role').addEventListener('change', function() {
            const mahasiswaDetails = document.getElementById('mahasiswa-details');
            if (this.value === 'mahasiswa') {
                mahasiswaDetails.style.display = 'block';
            } else {
                mahasiswaDetails.style.display = 'none';
            }
        });
    </script>
</body>
</html>