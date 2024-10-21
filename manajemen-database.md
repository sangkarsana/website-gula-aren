# Modul Praktikum: Sistem Manajemen Produk Gula Aren

## Tujuan Pembelajaran
Setelah menyelesaikan praktikum ini, mahasiswa diharapkan dapat:
1. Memahami konsep dasar CRUD (Create, Read, Update, Delete) dalam pengembangan aplikasi web.
2. Mengimplementasikan koneksi database menggunakan PHP dan MySQL.
3. Membuat form input dan menampilkan data dari database.
4. Menerapkan pemrograman berorientasi objek sederhana dalam PHP.

## Alat dan Bahan
1. XAMPP (atau server web lokal lainnya dengan PHP dan MySQL)
2. Text editor (misalnya Visual Studio Code, Sublime Text, atau Notepad++)
3. Web browser

## Langkah-langkah Praktikum

### Langkah 1: Persiapan Lingkungan
1. Pastikan XAMPP sudah terinstal dan berjalan.
2. Buat folder baru di `htdocs` dengan nama `praktikum_gula_aren`.

### Langkah 2: Membuat Database
1. Buka phpMyAdmin (http://localhost/phpmyadmin).
2. Buat database baru dengan nama `manajemen_gula_aren`.
3. Jalankan query SQL berikut untuk membuat tabel:

```sql
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    deskripsi TEXT
);

CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga DECIMAL(10, 2) NOT NULL,
    jumlah_stok INT NOT NULL DEFAULT 0,
    id_kategori INT,
    gambar VARCHAR(255),
    tanggal_dibuat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tanggal_diupdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori)
);

INSERT INTO kategori (nama, deskripsi) VALUES
('Gula Aren Original', 'Gula aren dalam bentuk padat/cetak'),
('Gula Aren Cair', 'Gula aren dalam bentuk cair'),
('Gula Semut', 'Gula aren dalam bentuk butiran halus');
```

### Langkah 3: Membuat Kelas Database
Buat file `Database.php` dengan isi berikut:

```php
<?php
class Database {
    private $host = 'localhost';
    private $db   = 'manajemen_gula_aren';
    private $user = 'root';
    private $pass = '';
    private $charset = 'utf8mb4';
    public $pdo;

    public function __construct() {
        $dsn = "mysql:host=$this->host;dbname=$this->db;charset=$this->charset";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $this->pdo = new PDO($dsn, $this->user, $this->pass, $options);
        } catch (\PDOException $e) {
            throw new \PDOException($e->getMessage(), (int)$e->getCode());
        }
    }
}
```

### Langkah 4: Membuat Kelas Produk
Buat file `Produk.php` dengan isi berikut:

```php
<?php
require_once 'Database.php';

class Produk {
    private $db;

    public function __construct() {
        $this->db = new Database();
    }

    public function tambahProduk($nama, $deskripsi, $harga, $jumlah_stok, $id_kategori, $gambar) {
        $sql = "INSERT INTO produk (nama, deskripsi, harga, jumlah_stok, id_kategori, gambar) VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = $this->db->pdo->prepare($sql);
        return $stmt->execute([$nama, $deskripsi, $harga, $jumlah_stok, $id_kategori, $gambar]);
    }

    public function ambilSemuaProduk() {
        $stmt = $this->db->pdo->query("SELECT * FROM produk");
        return $stmt->fetchAll();
    }

    // Tambahkan method untuk update dan delete di sini
}
```

### Langkah 5: Membuat Halaman Utama
Buat file `index.php` dengan isi berikut:

```php
<?php
require_once 'Produk.php';

$produk = new Produk();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nama = $_POST['nama'];
    $deskripsi = $_POST['deskripsi'];
    $harga = $_POST['harga'];
    $jumlah_stok = $_POST['jumlah_stok'];
    $id_kategori = $_POST['id_kategori'];
    $gambar = $_POST['gambar'];

    if ($produk->tambahProduk($nama, $deskripsi, $harga, $jumlah_stok, $id_kategori, $gambar)) {
        $message = "Produk berhasil ditambahkan!";
    } else {
        $message = "Gagal menambahkan produk.";
    }
}

$products = $produk->ambilSemuaProduk();
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Produk Gula Aren</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        form { background: #f9f9f9; padding: 20px; border-radius: 8px; }
        input, textarea, select { width: 100%; padding: 8px; margin: 5px 0 15px; }
        button { background: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
    </style>
</head>
<body>
    <h1>Manajemen Produk Gula Aren</h1>

    <?php if (isset($message)) echo "<p>$message</p>"; ?>

    <h2>Tambah Produk Baru</h2>
    <form method="post">
        <label for="nama">Nama Produk:</label>
        <input type="text" id="nama" name="nama" required>

        <label for="deskripsi">Deskripsi:</label>
        <textarea id="deskripsi" name="deskripsi" required></textarea>

        <label for="harga">Harga:</label>
        <input type="number" id="harga" name="harga" required>

        <label for="jumlah_stok">Jumlah Stok:</label>
        <input type="number" id="jumlah_stok" name="jumlah_stok" required>

        <label for="id_kategori">Kategori:</label>
        <select id="id_kategori" name="id_kategori" required>
            <option value="1">Gula Aren Original</option>
            <option value="2">Gula Aren Cair</option>
            <option value="3">Gula Semut</option>
        </select>

        <label for="gambar">URL Gambar:</label>
        <input type="text" id="gambar" name="gambar">

        <button type="submit">Tambah Produk</button>
    </form>

    <h2>Daftar Produk</h2>
    <table>
        <tr>
            <th>Nama</th>
            <th>Harga</th>
            <th>Stok</th>
            <th>Kategori</th>
        </tr>
        <?php foreach ($products as $product): ?>
        <tr>
            <td><?php echo htmlspecialchars($product['nama']); ?></td>
            <td>Rp <?php echo number_format($product['harga'], 0, ',', '.'); ?></td>
            <td><?php echo $product['jumlah_stok']; ?></td>
            <td><?php echo $product['id_kategori']; ?></td>
        </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
```

### Langkah 6: Pengujian
1. Buka browser dan akses `http://localhost/praktikum_gula_aren/index.php`.
2. Coba tambahkan beberapa produk dan lihat hasilnya di tabel.

## Tugas Tambahan
1. Tambahkan fitur untuk mengedit produk yang sudah ada.
2. Implementasikan fitur untuk menghapus produk.
3. Buat halaman terpisah untuk mengelola kategori produk.
4. Tambahkan validasi input di sisi klien menggunakan JavaScript.
5. Implementasikan paginasi untuk tabel produk.

## Kesimpulan
Dalam praktikum ini, mahasiswa telah belajar membuat sistem manajemen produk sederhana menggunakan PHP dan MySQL. Praktikum ini mencakup konsep dasar CRUD, koneksi database, dan pembuatan antarmuka web sederhana.

## Referensi
- PHP Manual: https://www.php.net/manual/en/
- MySQL Documentation: https://dev.mysql.com/doc/
- W3Schools PHP Tutorial: https://www.w3schools.com/php/
