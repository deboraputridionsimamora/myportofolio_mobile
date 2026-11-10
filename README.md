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