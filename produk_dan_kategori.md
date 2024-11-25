Pada kesempatan kali ini, kita akan mempelajari bagaimana membuat struktur database untuk sistem manajemen produk yang terdiri dari dua tabel utama yaitu tabel kategori dan tabel produk. Kedua tabel ini memiliki hubungan relasional one-to-many, di mana satu kategori dapat memiliki banyak produk, namun satu produk hanya dapat termasuk dalam satu kategori. Struktur database ini umum digunakan dalam berbagai aplikasi e-commerce atau sistem inventori untuk mengorganisir produk berdasarkan kategorinya. Tabel kategori akan menyimpan informasi dasar tentang jenis-jenis produk, sementara tabel produk akan menyimpan detail lengkap dari setiap item termasuk nama, deskripsi, harga, stok, dan URL gambar produk.

```mermaid
erDiagram
    KATEGORI ||--o{ PRODUK : memiliki
    KATEGORI {
        int id_kategori PK
        varchar nama_kategori
        text deskripsi
    }
    PRODUK {
        int id_produk PK
        int id_kategori FK
        varchar nama_produk
        text deskripsi
        decimal harga
        int stok
        varchar url_gambar
    }

```

Berikut query SQL untuk membuat tabel-tabel tersebut:

```sql
CREATE TABLE kategori (
    id_kategori INT PRIMARY KEY AUTO_INCREMENT,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi TEXT
);

CREATE TABLE produk (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    id_kategori INT,
    nama_produk VARCHAR(200) NOT NULL,
    deskripsi TEXT,
    harga DECIMAL(10,2) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    url_gambar VARCHAR(255),
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori)
);
```

Struktur lengkap:

1. Tabel KATEGORI:
   - id_kategori: Primary key, auto increment
   - nama_kategori: Nama kategori produk
   - deskripsi: Deskripsi kategori (opsional)

2. Tabel PRODUK:
   - id_produk: Primary key, auto increment
   - id_kategori: Foreign key yang merujuk ke tabel KATEGORI
   - nama_produk: Nama produk
   - deskripsi: Deskripsi produk
   - harga: Harga produk
   - stok: Jumlah stok produk
   - url_gambar: URL gambar produk (opsional)
