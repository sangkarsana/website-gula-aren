Berikut adalah cara mengunduh file Bootstrap untuk digunakan dalam proyek website:

### **Cara Mengunduh Bootstrap**:

1. **Buka Situs Resmi Bootstrap**:
   - Akses situs Bootstrap di [https://getbootstrap.com](https://getbootstrap.com).

2. **Navigasi ke Halaman Unduh**:
   - Klik tombol **Get Started** di bagian atas halaman.
   - Setelah masuk ke halaman "Get Started", gulir ke bawah hingga menemukan bagian **Download**.

3. **Unduh Versi Kompilasi CSS dan JS**:
   - Di bagian **Compiled CSS and JS**, klik tombol **Download** untuk mengunduh file yang telah dikompilasi.
   - File ini akan berformat `.zip` dan berisi file **CSS**, **JavaScript**, dan **icon** Bootstrap.

4. **Ekstrak File**:
   - Setelah file terunduh, ekstrak file `.zip` ke folder proyek website kamu.
   - Tempatkan file `bootstrap.min.css` di dalam folder `assets/css/` dan `bootstrap.min.js` di dalam folder `assets/js/`.

5. **Alternatif: CDN (Content Delivery Network)**:
   - Jika tidak ingin mengunduh file secara lokal, kamu bisa menggunakan **Bootstrap CDN** dengan menambahkan kode berikut ke dalam bagian `<head>` dan sebelum penutup `<body>` di file PHP kamu:
   
   ```html
   <!-- Tambahkan di bagian <head> -->
   <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
   
   <!-- Tambahkan sebelum penutup </body> -->
   <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
   ```

   **Kelebihan menggunakan CDN**:
   - Tidak perlu menyimpan file Bootstrap di server kamu.
   - File akan diambil dari server Bootstrap, sehingga pengunjung website dapat memuat file dari server yang lebih dekat dengan lokasi mereka.

6. **Menghubungkan Bootstrap dengan Proyek**:
   - Jika menggunakan file yang diunduh, pastikan kamu menambahkan tautan ke file CSS dan JS di dalam proyek PHP:
   
   Di dalam file **header.php**:
   ```php
   <link rel="stylesheet" href="assets/css/bootstrap.min.css">
   ```
   
   Di dalam file **footer.php**:
   ```php
   <script src="assets/js/bootstrap.min.js"></script>
   ```

Dengan langkah-langkah ini, kamu akan bisa menggunakan Bootstrap untuk membangun tampilan website yang responsif dan modern.
