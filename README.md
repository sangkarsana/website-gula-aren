### **Modul Ajar: Pembuatan Website Penjualan Gula Aren Menggunakan PHP dan Bootstrap**

#### **Mata Kuliah**: Web Programming  
#### **Durasi**: 1 Pertemuan (2 Jam)  
#### **Tujuan Pembelajaran**:
1. Mahasiswa memahami struktur dasar website penjualan menggunakan PHP dan Bootstrap.
2. Mahasiswa mampu membuat website sederhana dengan 3 halaman: Home, Produk, dan Kontak.
3. Mahasiswa mampu memanfaatkan Bootstrap untuk membuat tampilan responsif.

#### **Pendahuluan**:
Pada pertemuan ini, kita akan membuat **website penjualan gula aren** dengan struktur yang sederhana namun profesional menggunakan PHP dan Bootstrap. Website ini memiliki tiga halaman utama:
1. **Home**: Menjelaskan manfaat gula aren dan siapa yang cocok mengonsumsinya.
2. **Produk**: Katalog produk yang berisi berbagai jenis olahan gula aren (gula aren cair, gula aren semut, bandrex).
3. **Contact**: Berisi informasi kontak, email, nomor WhatsApp, dan lokasi bisnis.

---

### **Struktur Website**:

1. **File Struktur**:
   - `index.php` (Halaman Home)
   - `produk.php` (Halaman Produk)
   - `contact.php` (Halaman Kontak)
   - `header.php` (File untuk navigasi)
   - `footer.php` (File untuk footer)
   - **Folder `assets/`** (Menyimpan file CSS, gambar, dan JS):
     - `assets/css/bootstrap.min.css` (Bootstrap CSS)
     - `assets/js/bootstrap.min.js` (Bootstrap JS)
     - `assets/images/` (Folder untuk gambar produk)

2. **Navigasi Antar Halaman**:
   - Menggunakan Bootstrap untuk membuat **navbar** dan **footer** yang konsisten di setiap halaman.
   - Struktur navigasi berada di `header.php` yang akan disertakan di setiap halaman menggunakan PHP `include()`.

---

### **Langkah-Langkah Pembuatan**:

1. **Buat File `header.php`**:
   File ini berfungsi untuk menampilkan navigasi yang akan digunakan di seluruh halaman.
   ```php
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title><?php echo $title; ?></title>
       <link rel="stylesheet" href="assets/css/bootstrap.min.css">
   </head>
   <body>
   
   <!-- Navbar -->
   <nav class="navbar navbar-expand-lg navbar-light bg-light">
       <a class="navbar-brand" href="index.php">Gula Aren</a>
       <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
           <span class="navbar-toggler-icon"></span>
       </button>
       <div class="collapse navbar-collapse" id="navbarNav">
           <ul class="navbar-nav ml-auto">
               <li class="nav-item"><a class="nav-link" href="index.php">Home</a></li>
               <li class="nav-item"><a class="nav-link" href="produk.php">Produk</a></li>
               <li class="nav-item"><a class="nav-link" href="contact.php">Contact</a></li>
           </ul>
       </div>
   </nav>
   ```

2. **Buat File `footer.php`**:
   File ini akan berfungsi untuk menampilkan bagian bawah website.
   ```php
   <!-- Footer -->
   <footer class="bg-light text-center text-lg-start mt-5">
       <div class="text-center p-3" style="background-color: rgba(0, 0, 0, 0.2);">
           © 2024 Gula Aren Original | <a href="index.php">Home</a>
       </div>
   </footer>

   <script src="assets/js/bootstrap.min.js"></script>
   </body>
   </html>
   ```

3. **Buat File `index.php` (Halaman Home)**:
   Halaman ini menjelaskan manfaat gula aren dan mengajak pengunjung untuk melihat produk yang dijual.
   ```php
   <?php
   $title = "Gula Aren Original - Home";
   include('header.php');
   ?>

   <div class="container mt-5">
       <div class="row">
           <div class="col-md-6">
               <h1>Selamat Datang di Gula Aren Original</h1>
               <p>Gula aren memiliki manfaat luar biasa untuk kesehatan...</p>
               <a href="produk.php" class="btn btn-primary">Lihat Produk Kami</a>
           </div>
           <div class="col-md-6">
               <img src="assets/images/gula-aren.jpg" class="img-fluid" alt="Gula Aren">
           </div>
       </div>
   </div>

   <?php include('footer.php'); ?>
   ```

4. **Buat File `produk.php` (Halaman Produk)**:
   Halaman ini menampilkan katalog produk gula aren yang dijual.
   ```php
   <?php
   $title = "Gula Aren Original - Produk";
   include('header.php');
   ?>

   <div class="container mt-5">
       <h2>Katalog Produk Gula Aren</h2>
       <div class="row">
           <div class="col-md-4">
               <div class="card">
                   <img src="assets/images/gula-cair.jpg" class="card-img-top" alt="Gula Aren Cair">
                   <div class="card-body">
                       <h5 class="card-title">Gula Aren Cair</h5>
                       <a href="#" class="btn btn-primary">Beli Sekarang</a>
                   </div>
               </div>
           </div>
           <div class="col-md-4">
               <div class="card">
                   <img src="assets/images/gula-semut.jpg" class="card-img-top" alt="Gula Aren Semut">
                   <div class="card-body">
                       <h5 class="card-title">Gula Aren Semut</h5>
                       <a href="#" class="btn btn-primary">Beli Sekarang</a>
                   </div>
               </div>
           </div>
           <div class="col-md-4">
               <div class="card">
                   <img src="assets/images/bandrex.jpg" class="card-img-top" alt="Bandrex">
                   <div class="card-body">
                       <h5 class="card-title">Bandrex</h5>
                       <a href="#" class="btn btn-primary">Beli Sekarang</a>
                   </div>
               </div>
           </div>
       </div>
   </div>

   <?php include('footer.php'); ?>
   ```

5. **Buat File `contact.php` (Halaman Kontak)**:
   Halaman ini berisi informasi kontak yang dapat dihubungi.
   ```php
   <?php
   $title = "Gula Aren Original - Contact";
   include('header.php');
   ?>

   <div class="container mt-5">
       <h2>Hubungi Kami</h2>
       <p>Email: info@gulaarenoriginal.com</p>
       <p>Lokasi: Jl. Raya Gula Aren, Desa Aren Jaya</p>
       <p>WhatsApp: <a href="https://wa.me/6281234567890" target="_blank">+62 812 3456 7890</a></p>
   </div>

   <?php include('footer.php'); ?>
   ```

6. **Buat Folder `assets/`**:
   - **`assets/css/`**: Tempatkan file `bootstrap.min.css` di dalam folder ini.
   - **`assets/js/`**: Tempatkan file `bootstrap.min.js` di dalam folder ini.
   - **`assets/images/`**: Tempatkan gambar produk (contoh: `gula-aren.jpg`, `gula-cair.jpg`, `gula-semut.jpg`, `bandrex.jpg`) di sini.

---

### **Penutup**:
Dengan mengikuti langkah-langkah di atas, mahasiswa akan dapat membuat website penjualan produk dengan struktur yang baik menggunakan PHP dan Bootstrap. Website ini terdiri dari 3 halaman utama (Home, Produk, Contact) yang siap digunakan untuk menampilkan dan menjual produk secara online.

### **Tugas**:
1. Tambahkan lebih banyak produk di halaman `produk.php`.
2. Buat fitur interaktif seperti form untuk menghubungi melalui email di halaman `contact.php`.

Dengan modul ini, mahasiswa diharapkan dapat mengaplikasikan keterampilan dasar pemrograman web dan merancang website yang responsif dan fungsional.
