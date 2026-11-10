# MyPortfolio Mobile

Aplikasi mobile Flutter untuk portofolio pribadi, dibuat untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI, Semester Gasal 2026/2027. Proyek ini adalah lanjutan dari website portofolio Django saya (repositori terpisah bernama `myportofolio`).

**Nama:** Debora Putri Dion Simamora
**NPM:** 2506544126
**Kelas:** PBP A

## Fitur Saat Ini

- Halaman utama dengan 3 kartu informasi (`InfoCard`): NPM, Name, dan Class.
- 3 tombol menu (`ItemCard`) dengan warna latar berbeda:
  - Lihat Certification (biru)
  - Tambah Certification (hijau)
  - Logout (merah)
- Saat tombol ditekan, muncul `SnackBar` dengan pesan "Kamu telah menekan tombol [Nama Tombol]!".
- Tombol-tombol ini baru menampilkan `SnackBar`. Belum tersambung ke API Django, itu rencana untuk tahap berikutnya.

## Cara Menjalankan (Setup)

Prasyarat: Flutter SDK (stable) dan Google Chrome. Android Studio hanya dibutuhkan kalau mau memakai emulator Android.

1. Clone repositori ini:

```
git clone https://github.com/deboraputridionsimamora/myportofolio_mobile.git
cd myportofolio_mobile
```

2. Ambil dependensi:

```
flutter pub get
```

3. Jalankan di Chrome:

```
flutter run -d chrome
```

4. Cek kualitas kode:

```
flutter analyze
```

## Struktur Kode

- `lib/main.dart`: titik masuk aplikasi (`main()`), `MyApp`, dan pengaturan tema.
- `lib/menu.dart`: halaman menu utama `MyHomePage`, widget `InfoCard` dan `ItemCard`, serta model data `ItemHomepage`.

## Progres Mingguan

### Tutorial 08

Memasang Flutter SDK secara manual di Windows (ekstrak zip dan daftarkan `flutter\bin` ke PATH) dan Android Studio beserta Android SDK. `flutter doctor` sudah centang hijau untuk Flutter, Android toolchain, dan Chrome. Peringatan Visual Studio saya abaikan karena hanya dibutuhkan untuk aplikasi desktop Windows. Setelah itu saya membuat proyek `myportofolio_mobile`, menjalankannya di Chrome, memisahkan halaman menu ke `menu.dart`, mengubah `MyHomePage` menjadi `StatelessWidget`, mengganti tema warna, membuat widget `InfoCard` dan `ItemCard`, menambahkan `SnackBar`, menjalankan `flutter analyze` (No issues found), lalu push ke GitHub.

### Individual Assignment 7

Mengganti data contoh (Burhan) dengan data saya sendiri, mengganti tombol menu dengan tombol yang sesuai portofolio saya (Lihat Certification, Tambah Certification, Logout), dan menambahkan atribut `color` pada model `ItemHomepage` sehingga tiap tombol punya warna latar sendiri tanpa percabangan `if-else`. `flutter analyze` tetap bersih.