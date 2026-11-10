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

### Tugas 7

1. **Widget tree dan hubungan parent-child**

   Di Flutter, semua yang tampil di layar adalah widget, dan widget-widget itu disusun bersarang membentuk pohon (widget tree). Widget yang membungkus disebut parent, widget yang ada di dalamnya disebut child. Parent yang menentukan di mana child ditaruh dan seberapa besar ruang yang boleh dipakai child. Mirip struktur folder: folder (parent) berisi file atau folder lain (child).

   Di proyek ini pohonnya kira-kira: `MyApp` > `MaterialApp` > `MyHomePage` > `Scaffold` > (`AppBar` dan `body`) > `Padding` > `Column` > (`Row` berisi 3 `InfoCard`, `SizedBox`, `Center` > `Column` > (`Text` dan `GridView` berisi `ItemCard`)).

2. **Widget yang dipakai dan fungsinya**

   - `MaterialApp`: pembungkus aplikasi bergaya Material Design (tema, judul, halaman awal).
   - `Scaffold`: kerangka halaman (AppBar, body, tempat SnackBar muncul).
   - `AppBar`: bar judul di atas halaman.
   - `Text`: menampilkan tulisan.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column`: menyusun child ke bawah (vertikal).
   - `Row`: menyusun child ke samping (horizontal), dipakai untuk 3 `InfoCard`.
   - `SizedBox`: memberi jarak kosong dengan ukuran tertentu.
   - `Center`: menaruh child di tengah.
   - `GridView.count`: menyusun child dalam grid dengan jumlah kolom tetap (3 kolom).
   - `Card`: kotak dengan bayangan, dipakai di `InfoCard`.
   - `Container`: kotak serbaguna untuk mengatur lebar, padding, dan isi.
   - `Material`: permukaan dengan warna dan sudut membulat, dipakai di `ItemCard`.
   - `InkWell`: membuat area bisa ditekan dengan efek riak (ripple).
   - `Icon`: menampilkan ikon.
   - `SnackBar`: notifikasi singkat di bawah layar (ditampilkan lewat `ScaffoldMessenger`).
   - Widget buatan sendiri: `MyApp`, `MyHomePage`, `InfoCard`, `ItemCard`.

   `ItemHomepage` bukan widget, tapi kelas model data (nama, ikon, warna).

3. **Fungsi `MaterialApp` dan kenapa jadi root widget**

   `MaterialApp` menyediakan pengaturan dasar aplikasi bergaya Material Design: tema (warna dan font), judul aplikasi, halaman awal (`home`), serta sistem navigasi antar halaman. Dia juga menyediakan `ScaffoldMessenger` yang dibutuhkan agar `SnackBar` bisa muncul. Karena widget-widget di bawahnya butuh info dari atas (misalnya `Theme.of(context)`), `MaterialApp` umumnya ditaruh paling atas sebagai root supaya semua halaman mendapat tema dan navigasi yang sama. Ini kebiasaan umum untuk aplikasi Material, bukan satu-satunya cara (ada juga `CupertinoApp` untuk gaya iOS).

4. **`StatelessWidget` vs `StatefulWidget`**

   `StatelessWidget` tidak punya data yang berubah. Tampilannya hanya bergantung pada data yang diberikan saat widget dibuat. `StatefulWidget` punya objek `State` terpisah yang menyimpan data yang bisa berubah, dan memanggil `setState()` membuat tampilan digambar ulang.

   Pilih `StatelessWidget` kalau tampilannya tetap, seperti halaman menu saya (NPM, nama, kelas, daftar tombol). Pilih `StatefulWidget` kalau ada data yang berubah akibat interaksi, misalnya penghitung angka di aplikasi bawaan Flutter, isi form, checkbox, atau animasi.

5. **`BuildContext`**

   `BuildContext` adalah penunjuk lokasi sebuah widget di dalam widget tree. Fungsinya supaya widget bisa "naik ke atas pohon" untuk mengambil data dari widget di atasnya (ancestor). Di method `build`, `context` dipakai untuk:
   - `Theme.of(context).colorScheme.primary`: mengambil warna tema untuk `AppBar`.
   - `MediaQuery.of(context).size.width`: mengambil lebar layar untuk lebar `InfoCard`.
   - `ScaffoldMessenger.of(context)`: menampilkan `SnackBar`.

6. **Hot reload, hot restart, dan full restart**

   - **Hot reload** (`r`): memasukkan kode baru ke aplikasi yang sedang jalan tanpa memulai ulang, dan state tetap dipertahankan. Cepat, cocok untuk mengubah tampilan.
   - **Hot restart** (`R`): memulai ulang aplikasi dari `main()` dengan kode terbaru, sehingga state kembali ke awal. Lebih lambat dari hot reload, tapi lebih cepat dari full restart.
   - **Full restart** (stop lalu `flutter run` lagi): menghentikan aplikasi dan membangunnya ulang dari nol.

   Hot reload saja tidak cukup kalau mengubah `main()`, nilai awal variabel global atau field, atau struktur kelas (misalnya menambah field di constructor), karena perubahan itu baru terbaca saat aplikasi mulai dari awal, jadi pakai hot restart. Full restart dibutuhkan kalau menambah dependensi di `pubspec.yaml`, menambah plugin atau aset baru, atau mengubah kode native di folder `android`, `ios`, dan sejenisnya.

   ## AI Disclosure: Tutorial 08 dan Individual Assignment 7

### Tools yang Dipakai

Claude (Anthropic), dipakai lewat satu sesi chat yang sama dari awal instalasi sampai README ini selesai.

### Bagian yang Dibantu AI

- Memandu instalasi Flutter SDK dan Android Studio langkah demi langkah, serta membantu membaca hasil `flutter doctor`.
- Membantu mencari penyebab error yang saya temui (PATH yang belum terbaca, dan folder Flutter yang tidak bisa dihapus karena masalah izin).
- Menuliskan kode `lib/main.dart` dan `lib/menu.dart`. Kodenya mengikuti contoh di modul Tutorial 08 dan petunjuk Individual Assignment 7, lalu disesuaikan dengan data, nama tombol, dan warna.
- Menjelaskan perintah Git dan membaca keluarannya bersama saya.
- Membuat draft jawaban pertanyaan reflektif (Tugas 7) dan draft README ini.

### Bagian yang Saya Kerjakan Sendiri

- Menjalankan semua instalasi dan perintah di laptop saya sendiri: download dan ekstrak Flutter, mengatur PATH, `flutter doctor`, `flutter create`, `flutter run`, dan `flutter analyze`.
- Membuat repositori GitHub `myportofolio_mobile`, menempelkan kode ke VS Code, menjalankan aplikasi di Chrome, dan mengecek tampilannya.
- Melakukan `git add`, `commit`, dan `push`, serta submit ke SCELE.
- Menentukan data diri yang dipakai dan memilih tema "Certification" untuk tombol menu karena itu bagian portofolio Django saya.
- Meminta langkah yang lebih jelas ketika petunjuk terasa membingungkan, meminta README dikerjakan bertahap, dan meminta riwayat commit dipisah ulang supaya perubahan data diri dan warna tidak tergabung dalam satu commit.

### Strategi Prompting

Saya mengunggah PDF modul dan meminta dipandu langkah demi langkah. Setiap ada error, saya menempelkan keluaran terminal atau screenshot ke chat supaya AI melihat kondisi sebenarnya di laptop saya. Kalau penjelasannya kurang jelas, saya minta diulang dengan langkah yang lebih rinci, dan kode saya minta ditampilkan langsung di chat.

### AI Chat / Prompting Log

1. Saat Flutter gagal membuat proyek, saya menempelkan error ini:

   > Flutter failed to delete a directory at "C:\src\flutter\.pub-preload-cache". The flutter tool cannot access the file or directory.

   Hasilnya: AI menjelaskan kemungkinan masalah izin akses dan menyarankan menghapus folder itu secara manual, lalu mengulang `flutter create`. Saya menjalankannya dan proyek berhasil dibuat.

2. Saat aplikasi sudah di-run, saya menanyakan:

   > Bagaimana cara membuka tab terminal baru di dalam VS Code untuk menjalankan perintah lain tanpa menghentikan proses flutter run yang sedang berjalan?

   Hasilnya: AI menjelaskan bahwa terminal VS Code bisa dipakai, dan terminal yang menjalankan `flutter run` sebaiknya jangan dipakai untuk mengetik perintah lain.

3. Saat langkah-langkah dari AI terasa membingungkan, saya menulis:

   > "Tolong berikan panduan step-by-step yang lebih detail dan spesifik. Sebutkan nama menu/tombol yang harus diklik, lokasi file yang perlu dibuka."

   Hasilnya: AI mengulang langkahnya dengan lokasi yang jelas (menu mana yang dibuka, file mana yang diedit).

4. Saat saya melihat perubahan data diri dan warna masuk ke satu commit, saya menulis:

   > Saya mau memisahkan perubahan warna dan perubahan data diri menjadi 2 commit terpisah. Tolong berikan perintah Git untuk batalkan commit terakhir tanpa menghapus perubahan kode, lalu langkah-langkah untuk push ulang secara aman.

   Hasilnya: AI memberi langkah untuk membatalkan commit terakhir, memisahkannya menjadi dua commit, lalu push ulang dengan `--force-with-lease`. Saya menjalankan langkah itu dan riwayatnya sekarang terpisah.


### Keterbatasan AI dan catatan

Meskipun sangat membantu dalam proses pengembangan, terdapat keterbatasan utama dari AI (Claude) karena tidak memiliki akses langsung untuk melihat atau mengeksekusi kode di lingkungan lokal laptop saya. AI sempat memberikan instruksi yang kurang spesifik terkait alur kerja dan navigasi UI—seperti lokasi pasti menu terminal di VS Code—serta mengasumsikan posisi direktori terminal tanpa memverifikasinya terlebih dahulu, yang menyebabkan beberapa perintah awal sempat gagal. Selain itu, AI tidak secara otomatis menerapkan *best practice* manajemen Git, seperti ketika menggabungkan perubahan data diri dan warna ke dalam satu *commit*, sehingga validasi manual, pengujian lewat `flutter analyze`, serta arahan ulang dari saya tetap mutlak diperlukan untuk memastikan keakuratan kode dan kerapihan riwayat *commit*.