Berikut adalah contoh script PHP sederhana yang dapat digunakan untuk menangani inputan form order gula aren:

### 1. Form Order Gula Aren (HTML)
```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Order Gula Aren</title>
</head>
<body>
    <h1>Form Order Gula Aren</h1>
    <form action="proses_order.php" method="POST">
        <label for="nama">Nama Lengkap:</label><br>
        <input type="text" id="nama" name="nama" required><br><br>

        <label for="alamat">Alamat Pengiriman:</label><br>
        <textarea id="alamat" name="alamat" required></textarea><br><br>

        <label for="jumlah">Jumlah Pesanan (kg):</label><br>
        <input type="number" id="jumlah" name="jumlah" min="1" required><br><br>

        <label for="email">Email:</label><br>
        <input type="email" id="email" name="email" required><br><br>

        <label for="telepon">Nomor Telepon:</label><br>
        <input type="text" id="telepon" name="telepon" required><br><br>

        <button type="submit">Kirim Order</button>
    </form>
</body>
</html>
```

### 2. Script PHP untuk Menghandle Form (proses_order.php)
```php
<?php
// Periksa apakah form telah disubmit
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Ambil data dari form
    $nama = htmlspecialchars(trim($_POST['nama']));
    $alamat = htmlspecialchars(trim($_POST['alamat']));
    $jumlah = intval($_POST['jumlah']);
    $email = htmlspecialchars(trim($_POST['email']));
    $telepon = htmlspecialchars(trim($_POST['telepon']));

    // Validasi sederhana (pastikan semua data terisi)
    if (!empty($nama) && !empty($alamat) && $jumlah > 0 && !empty($email) && !empty($telepon)) {
        // Proses data, misalnya: simpan ke database, kirim email, dll.
        
        // Contoh: menampilkan pesan sukses
        echo "<h2>Terima kasih, $nama! Pesanan Anda telah diterima.</h2>";
        echo "<p>Detail pesanan:</p>";
        echo "<ul>";
        echo "<li>Nama: $nama</li>";
        echo "<li>Alamat Pengiriman: $alamat</li>";
        echo "<li>Jumlah Pesanan: $jumlah kg</li>";
        echo "<li>Email: $email</li>";
        echo "<li>Telepon: $telepon</li>";
        echo "</ul>";
    } else {
        // Jika ada data yang tidak valid
        echo "<h2>Error: Pastikan semua data telah diisi dengan benar!</h2>";
    }
} else {
    // Jika form belum disubmit
    echo "<h2>Error: Form belum disubmit!</h2>";
}
?>
```

### Penjelasan:
1. **Form HTML**: Terdapat field untuk mengisi nama lengkap, alamat pengiriman, jumlah pesanan, email, dan nomor telepon. Form ini akan dikirim menggunakan metode `POST` ke file `proses_order.php`.
2. **Script PHP (proses_order.php)**:
   - Mengambil data inputan dari form menggunakan `$_POST`.
   - Dilakukan validasi sederhana seperti pengecekan apakah semua field terisi dan jumlah pesanan valid.
   - Setelah semua validasi berhasil, ditampilkan konfirmasi pesanan.
   - Jika terjadi kesalahan, pesan error akan ditampilkan.

