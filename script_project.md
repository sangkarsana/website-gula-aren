Script lengkap untuk setiap file dalam struktur project login.

```php
// config/database.php
<?php
function connectDB() {
    $host = "localhost";
    $user = "root";
    $pass = "";
    $db = "manajemen_gula_aren";
    
    $conn = mysqli_connect($host, $user, $pass, $db);
    if (!$conn) {
        die("Koneksi gagal: " . mysqli_connect_error());
    }
    return $conn;
}

// auth/check_session.php
<?php
function checkSession() {
    session_start();
    if (!isset($_SESSION['user_id'])) {
        header("Location: ../login.php");
        exit();
    }
}

function checkAdmin() {
    if ($_SESSION['role'] !== 'admin') {
        header("Location: ../dashboard.php");
        exit();
    }
}

// assets/css/style.css
body {
    background-color: #f8f9fa;
}

.login-container {
    margin-top: 100px;
}

.dashboard-stats .card {
    transition: all 0.3s;
}

.dashboard-stats .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.navbar-custom {
    padding: 15px 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

// assets/js/script.js
document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            if (!username || !password) {
                e.preventDefault();
                alert('Username dan password harus diisi!');
            }
        });
    }
    
    // Tooltips initialization
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });
});

// login.php
<?php
session_start();
if(isset($_SESSION['user_id'])) {
    header("Location: dashboard.php");
    exit();
}

require_once 'config/database.php';
$error = "";

if(isset($_POST['login'])) {
    $conn = connectDB();
    
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = $_POST['password'];
    
    if(empty($username) || empty($password)) {
        $error = "Username dan password harus diisi!";
    } else {
        $query = "SELECT * FROM users WHERE username = ?";
        $stmt = mysqli_prepare($conn, $query);
        mysqli_stmt_bind_param($stmt, "s", $username);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);
        
        if($user = mysqli_fetch_assoc($result)) {
            if(password_verify($password, $user['password'])) {
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['username'] = $user['username'];
                $_SESSION['nama_lengkap'] = $user['nama_lengkap'];
                $_SESSION['role'] = $user['role'];
                
                // Log successful login
                $ip = $_SERVER['REMOTE_ADDR'];
                $log_query = "INSERT INTO login_logs (user_id, ip_address, status) VALUES (?, ?, 'success')";
                $log_stmt = mysqli_prepare($conn, $log_query);
                mysqli_stmt_bind_param($log_stmt, "is", $user['id'], $ip);
                mysqli_stmt_execute($log_stmt);
                
                header("Location: dashboard.php");
                exit();
            } else {
                $error = "Password salah!";
            }
        } else {
            $error = "Username tidak ditemukan!";
        }
        mysqli_close($conn);
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Manajemen Gula Aren</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-body">
                        <h4 class="card-title text-center mb-4">Login Sistem</h4>
                        <?php if($error): ?>
                            <div class="alert alert-danger"><?php echo $error; ?></div>
                        <?php endif; ?>
                        
                        <form id="loginForm" method="POST" action="">
                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <input type="text" name="username" id="username" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" id="password" class="form-control" required>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" name="remember" class="form-check-input" id="remember">
                                <label class="form-check-label" for="remember">Remember me</label>
                            </div>
                            <button type="submit" name="login" class="btn btn-primary w-100">Login</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/script.js"></script>
</body>
</html>

// dashboard.php
<?php
require_once 'auth/check_session.php';
checkSession();
require_once 'config/database.php';
$conn = connectDB();

// Get statistics
$query = "SELECT 
    (SELECT COUNT(*) FROM produksi) as total_produksi,
    (SELECT SUM(jumlah) FROM penjualan) as total_penjualan,
    (SELECT SUM(stok) FROM produk) as total_stok";
$result = mysqli_query($conn, $query);
$stats = mysqli_fetch_assoc($result);
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Manajemen Gula Aren</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class='bx bx-store-alt'></i> Manajemen Gula Aren
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="dashboard.php">
                            <i class='bx bx-home'></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="produksi.php">
                            <i class='bx bx-factory'></i> Produksi
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="penjualan.php">
                            <i class='bx bx-cart'></i> Penjualan
                        </a>
                    </li>
                    <?php if($_SESSION['role'] == 'admin'): ?>
                    <li class="nav-item">
                        <a class="nav-link" href="users.php">
                            <i class='bx bx-user'></i> Kelola User
                        </a>
                    </li>
                    <?php endif; ?>
                </ul>
                <div class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                           data-bs-toggle="dropdown">
                           <i class='bx bx-user-circle'></i> <?php echo $_SESSION['nama_lengkap']; ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="profile.php">
                                    <i class='bx bx-user'></i> Profile
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="logout.php">
                                    <i class='bx bx-log-out'></i> Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Selamat Datang, <?php echo $_SESSION['nama_lengkap']; ?>!</h5>
                        <p class="card-text">
                            Anda login sebagai <?php echo ucfirst($_SESSION['role']); ?>. 
                            Silakan gunakan menu di atas untuk navigasi.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistik Dashboard -->
        <div class="row dashboard-stats">
            <div class="col-md-4">
                <div class="card bg-primary text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Produksi</h6>
                                <h3 class="mt-2 mb-0"><?php echo number_format($stats['total_produksi']); ?> Kg</h3>
                            </div>
                            <i class='bx bx-package bx-lg'></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Penjualan</h6>
                                <h3 class="mt-2 mb-0">Rp <?php echo number_format($stats['total_penjualan']); ?></h3>
                            </div>
                            <i class='bx bx-money bx-lg'></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-info text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Stok Tersedia</h6>
                                <h3 class="mt-2 mb-0"><?php echo number_format($stats['total_stok']); ?> Kg</h3>
                            </div>
                            <i class='bx bx-box bx-lg'></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Aktivitas Terakhir</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Tanggal</th>
                                        <th>Aktivitas</th>
                                        <th>User</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $query = "SELECT * FROM activity_logs ORDER BY created_at DESC LIMIT 5";
                                    $result = mysqli_query($conn, $query);
                                    while($row = mysqli_fetch_assoc($result)):
                                    ?>
                                    <tr>
                                        <td><?php echo date('d/m/Y H:i', strtotime($row['created_at'])); ?></td>
                                        <td><?php echo $row['activity']; ?></td>
                                        <td><?php echo $row['user']; ?></td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Stok Menipis</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Produk</th>
                                        <th>Stok</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $query = "SELECT * FROM produk WHERE stok < minimum_stok ORDER BY stok ASC LIMIT 5";
                                    // dashboard.php (lanjutan)
                                    $result = mysqli_query($conn, $query);
                                    while($row = mysqli_fetch_assoc($result)):
                                    ?>
                                    <tr>
                                        <td><?php echo $row['nama_produk']; ?></td>
                                        <td><?php echo $row['stok']; ?> Kg</td>
                                        <td>
                                            <span class="badge bg-danger">Stok Menipis</span>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/script.js"></script>
</body>
</html>

// logout.php
<?php
session_start();
require_once 'config/database.php';
$conn = connectDB();

// Log logout activity
if(isset($_SESSION['user_id'])) {
    $user_id = $_SESSION['user_id'];
    $ip = $_SERVER['REMOTE_ADDR'];
    $query = "INSERT INTO login_logs (user_id, ip_address, status, action) VALUES (?, ?, 'success', 'logout')";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "is", $user_id, $ip);
    mysqli_stmt_execute($stmt);
}

session_destroy();
header("Location: login.php");
exit();

// File tambahan yang diperlukan:

// includes/header.php
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $page_title; ?> - Manajemen Gula Aren</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

// includes/navbar.php
<nav class="navbar navbar-expand-lg navbar-dark bg-dark navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class='bx bx-store-alt'></i> Manajemen Gula Aren
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <!-- Menu items -->
            </ul>
            <div class="navbar-nav">
                <!-- User dropdown -->
            </div>
        </div>
    </div>
</nav>

// includes/footer.php
    <footer class="footer mt-auto py-3 bg-light">
        <div class="container text-center">
            <span class="text-muted">© <?php echo date('Y'); ?> Manajemen Gula Aren. All rights reserved.</span>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/script.js"></script>
</body>
</html>

// functions/helpers.php
<?php
function formatRupiah($angka) {
    return "Rp " . number_format($angka, 0, ',', '.');
}

function formatTanggal($tanggal) {
    return date('d/m/Y', strtotime($tanggal));
}

function getStatus($status) {
    $badges = [
        'pending' => 'bg-warning',
        'success' => 'bg-success',
        'failed' => 'bg-danger'
    ];
    return "<span class='badge " . $badges[$status] . "'>" . ucfirst($status) . "</span>";
}

function logActivity($conn, $user_id, $activity) {
    $query = "INSERT INTO activity_logs (user_id, activity) VALUES (?, ?)";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "is", $user_id, $activity);
    mysqli_stmt_execute($stmt);
}

// SQL untuk tabel tambahan

// Tabel activity_logs
CREATE TABLE activity_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    activity TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

// Tabel login_logs
CREATE TABLE login_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ip_address VARCHAR(45),
    status ENUM('success', 'failed'),
    action ENUM('login', 'logout') DEFAULT 'login',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

// Tabel produk
CREATE TABLE produk (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga DECIMAL(10,2) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    minimum_stok INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

// Tabel produksi
CREATE TABLE produksi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    jumlah INT NOT NULL,
    keterangan TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

// Tabel penjualan
CREATE TABLE penjualan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    produk_id INT,
    jumlah INT NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    customer VARCHAR(100),
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produk_id) REFERENCES produk(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

// produksi.php (contoh halaman tambahan)
<?php
require_once 'auth/check_session.php';
checkSession();
require_once 'config/database.php';
require_once 'functions/helpers.php';

$page_title = "Data Produksi";
include 'includes/header.php';
include 'includes/navbar.php';

$conn = connectDB();

// Handle form submission
if(isset($_POST['submit'])) {
    $tanggal = $_POST['tanggal'];
    $jumlah = $_POST['jumlah'];
    $keterangan = $_POST['keterangan'];
    $user_id = $_SESSION['user_id'];
    
    $query = "INSERT INTO produksi (tanggal, jumlah, keterangan, user_id) VALUES (?, ?, ?, ?)";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "sisi", $tanggal, $jumlah, $keterangan, $user_id);
    
    if(mysqli_stmt_execute($stmt)) {
        logActivity($conn, $user_id, "Menambah data produksi: $jumlah Kg");
        $success = "Data produksi berhasil ditambahkan";
    } else {
        $error = "Gagal menambahkan data produksi";
    }
}

// Get produksi data
$query = "SELECT p.*, u.nama_lengkap 
          FROM produksi p 
          JOIN users u ON p.user_id = u.id 
          ORDER BY p.tanggal DESC";
$result = mysqli_query($conn, $query);
?>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Data Produksi</h5>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class='bx bx-plus'></i> Tambah Data
                    </button>
                </div>
                <div class="card-body">
                    <?php if(isset($success)): ?>
                        <div class="alert alert-success"><?php echo $success; ?></div>
                    <?php endif; ?>
                    <?php if(isset($error)): ?>
                        <div class="alert alert-danger"><?php echo $error; ?></div>
                    <?php endif; ?>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Tanggal</th>
                                    <th>Jumlah (Kg)</th>
                                    <th>Keterangan</th>
                                    <th>Operator</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php while($row = mysqli_fetch_assoc($result)): ?>
                                <tr>
                                    <td><?php echo formatTanggal($row['tanggal']); ?></td>
                                    <td><?php echo number_format($row['jumlah']); ?> Kg</td>
                                    <td><?php echo $row['keterangan']; ?></td>
                                    <td><?php echo $row['nama_lengkap']; ?></td>
                                    <td>
                                        <button class="btn btn-sm btn-info" title="Edit">
                                            <i class='bx bx-edit'></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" title="Hapus">
                                            <i class='bx bx-trash'></i>
                                        </button>
                                    </td>
                                </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Tambah Data -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Tambah Data Produksi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tanggal</label>
                        <input type="date" name="tanggal" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jumlah (Kg)</label>
                        <input type="number" name="jumlah" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Keterangan</label>
                        <textarea name="keterangan" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" name="submit" class="btn btn-primary">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php
include 'includes/footer.php';
?>
```
