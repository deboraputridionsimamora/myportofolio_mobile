# MyPortfolio Mobile

[![CI](https://github.com/deboraputridionsimamora/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/deboraputridionsimamora/myportofolio_mobile/actions/workflows/main.yaml)

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
- Tombol Lihat Certification juga menampilkan dialog (`AlertDialog`) berisi daftar sertifikat saya. Fitur ini dikerjakan di branch `feat/certification-dialog` lalu di-merge ke `main`.
- Tombol-tombol ini baru menampilkan `SnackBar`. Belum tersambung ke API Django, itu rencana untuk tahap berikutnya.

## Cara Menjalankan (Setup)

Prasyarat: Flutter SDK (stable) dan Google Chrome. Android Studio hanya dibutuhkan kalau mau memakai emulator Android.

1. Clone repositori ini:

```bash
git clone [https://github.com/deboraputridionsimamora/myportofolio_mobile.git](https://github.com/deboraputridionsimamora/myportofolio_mobile.git)
cd myportofolio_mobile
```

2. Ambil dependensi:

```bash
flutter pub get
```

3. Jalankan di Chrome:

```bash
flutter run -d chrome
```

4. Cek kualitas kode:

```bash
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

### AI Disclosure: Tutorial 08 dan Individual Assignment 7

#### Tools yang Dipakai

Claude (Anthropic), dipakai lewat satu sesi chat yang sama dari awal instalasi sampai README ini selesai.

#### Bagian yang Dibantu AI

- Memandu instalasi Flutter SDK dan Android Studio langkah demi langkah, serta membantu membaca hasil `flutter doctor`.
- Membantu mencari penyebab error yang saya temui (PATH yang belum terbaca, dan folder Flutter yang tidak bisa dihapus karena masalah izin).
- Menuliskan kode `lib/main.dart` dan `lib/menu.dart`. Kodenya mengikuti contoh di modul Tutorial 08 dan petunjuk Individual Assignment 7, lalu disesuaikan dengan data, nama tombol, dan warna.
- Menuliskan kode fitur tambahan dialog daftar sertifikat (`AlertDialog`, model `CertificationItem`, dan parameter `onTap` pada `ItemHomepage`).
- Menjelaskan perintah Git dan membaca keluarannya bersama saya.
- Membuat draft jawaban pertanyaan reflektif (Tugas 7) dan draft README ini.

#### Bagian yang Saya Kerjakan Sendiri

- Menjalankan semua instalasi dan perintah di laptop saya sendiri: download dan ekstrak Flutter, mengatur PATH, `flutter doctor`, `flutter create`, `flutter run`, dan `flutter analyze`.
- Membuat repositori GitHub `myportofolio_mobile`, menempelkan kode ke VS Code, menjalankan aplikasi di Chrome, dan mengecek tampilannya.
- Melakukan `git add`, `commit`, dan `push`, serta submit ke SCELE.
- Membuat branch `feat/certification-dialog`, menguji dialog di Chrome, menjalankan `flutter analyze`, lalu merge ke `main`.
- Menentukan data diri yang dipakai dan memilih tema "Certification" untuk tombol menu karena itu bagian portofolio Django saya.
- Meminta langkah yang lebih jelas ketika petunjuk terasa membingungkan, meminta README dikerjakan bertahap, dan meminta riwayat commit dipisah ulang supaya perubahan data diri dan warna tidak tergabung dalam satu commit.

#### Strategi Prompting

Saya mengunggah PDF modul dan meminta dipandu langkah demi langkah. Setiap ada error, saya menempelkan keluaran terminal atau screenshot ke chat supaya AI melihat kondisi sebenarnya di laptop saya. Kalau penjelasannya kurang jelas, saya minta diulang dengan langkah yang lebih rinci, dan kode saya minta ditampilkan langsung di chat.

#### AI Chat / Prompting Log

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

#### Keterbatasan AI dan Catatan

- Daftar sertifikat di dialog masih ditulis manual di kode (`lib/menu.dart`), belum diambil dari database atau API Django, sehingga kalau data di website berubah, daftar di aplikasi harus diubah manual.
- AI (Claude) tidak bisa melihat atau menjalankan kode di laptop saya, jadi kodenya baru terbukti jalan setelah saya menjalankannya sendiri dan `flutter analyze` menyatakan "No issues found".
- AI sempat memberikan instruksi yang kurang spesifik soal alur kerja dan navigasi, misalnya lokasi menu terminal di VS Code dan posisi direktori terminal yang tidak diverifikasi dulu, sehingga beberapa perintah awal sempat gagal atau salah tempat.
- Rencana awal dua commit bertahap (data diri dulu, lalu warna) ternyata menjadi satu commit, karena kode yang saya tempel sudah termasuk warna. Setelah saya minta, riwayatnya dipisah ulang dengan force push. Commit Tutorial 08 tidak terpengaruh.
- Jawaban pertanyaan reflektif didraf oleh AI, bukan sepenuhnya ditulis dengan kata-kata saya sendiri.
- Karena itu, pengecekan manual (menjalankan aplikasi, `flutter analyze`, dan memeriksa riwayat commit) tetap saya lakukan sendiri.

---

## Tutorial 09 dan Individual Assignment 8

### Progres

**Tutorial 09:** Menambahkan navigasi drawer (`LeftDrawer`), halaman formulir proyek (`ProjectFormPage`) lengkap dengan validasi dan *dialog* ringkasan, menyambungkan navigasi antarhalaman dari tombol maupun drawer, serta merapikan struktur direktori ke dalam `lib/screens/` dan `lib/widgets/`.

**Individual Assignment 8:** Mengimplementasikan halaman formulir penambahan sertifikat (`CertificationFormPage`) yang memiliki 4 *field* input: Nama Sertifikat, Penerbit, Tanggal Diperoleh (menggunakan `showDatePicker`), dan Tautan Kredensial (opsional). Halaman ini dapat diakses melalui kartu "Tambah Certification" di halaman utama (`Navigator.push`) maupun melalui opsi "Add Certification" di drawer. Jika seluruh input valid saat tombol Simpan ditekan, sistem menampilkan *pop-up dialog* ringkasan data. *(Catatan: Data saat ini masih bersifat sementara/statis dan belum dihubungkan ke database atau API Django).*

**Struktur Kode Terkini:**
- `lib/main.dart`: Titik masuk aplikasi (`main`) dan pengaturan tema global.
- `lib/screens/menu.dart`: Halaman utama (`MyHomePage`), widget `InfoCard`, model data `ItemHomepage`, serta *dialog* daftar sertifikat.
- `lib/screens/project_form.dart`: Halaman formulir proyek (Tutorial 09).
- `lib/screens/certification_form.dart`: Halaman formulir sertifikat (Individual Assignment 8).
- `lib/widgets/left_drawer.dart`: Komponen navigasi *drawer* yang digunakan bersama di seluruh halaman.
- `lib/widgets/project_card.dart`: Komponen kartu menu (`ItemCard`).

### Tugas 8

1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`**

   - **`Navigator.push()`** menumpuk halaman baru di atas halaman yang sedang aktif, sehingga halaman sebelumnya tetap tersimpan di *stack* navigasi dan pengguna bisa kembali menggunakan tombol *Back*.
   - **`Navigator.pushReplacement()`** menggantikan halaman yang sedang aktif dengan halaman baru. Halaman lama dihapus dari *stack*, sehingga pengguna tidak bisa kembali ke halaman sebelumnya.
   - **`Navigator.pop()`** menutup atau mengeluarkan halaman paling atas dari *stack* untuk kembali ke halaman tepat di bawahnya.

   Pada proyek ini, saya menerapkan `Navigator.push()` di `ItemCard` (`lib/widgets/project_card.dart`) saat pengguna menekan kartu untuk membuka formulir, agar mereka tetap bisa membatalkan pengisian dan kembali ke beranda lewat tombol *Back*. Sebaliknya, pada opsi *Home* di `LeftDrawer`, saya menggunakan `Navigator.pushReplacement()` menuju `MyHomePage` agar tumpukan halaman tidak menumpuk terus-menerus saat pengguna berpindah menu. Alur ini sudah saya uji langsung di Chrome dengan berpindah dari halaman formulir kembali ke beranda lewat drawer.

2. **Peran `Scaffold`, `AppBar`, dan `Drawer` dalam Menjaga Konsistensi Halaman**

   `Scaffold` menyediakan kerangka tata letak standar (bagian atas untuk `AppBar`, tengah untuk `body`, dan sisi kiri untuk `Drawer`) sehingga struktur antarmuka terasa seragam di setiap layar. `AppBar` menjaga konsistensi identitas judul dan warna tema di bagian atas, sementara `Drawer` memastikan akses navigasi yang identik di semua halaman karena cukup memanggil satu komponen `LeftDrawer` yang sama secara berulang tanpa perlu menulis ulang kodenya.

   Sebagai contoh konsistensi visual, `AppBar` pada halaman utama (`lib/screens/menu.dart`) dan halaman formulir sertifikat (`lib/screens/certification_form.dart`) sama-sama mengambil warna dari `Theme.of(context).colorScheme.primary` dengan warna teks dan ikon putih, yang bersumber dari palet warna *indigo* (`ColorScheme.fromSeed`) di `main.dart`. Bagian header drawer dan formulir proyek pun menggunakan turunan warna *indigo* yang senada.

3. **Alasan Tata Letak Formulir dan Peran Widget Pengatur Jarak & Penggulir**

   Elemen input pada formulir disusun secara vertikal menggunakan `Column` agar alur pengisian dari atas ke bawah terasa alami bagi pengguna. Setiap kolom input dibungkus dengan `Padding` untuk memberi ruang bernapas antar-komponen maupun dengan tepi layar, sehingga tampilan tidak menumpuk dan area sentuh tetap nyaman.

   Seluruh `Column` kemudian dibungkus ke dalam `SingleChildScrollView` agar halaman tetap dapat digulir (*scroll*) saat ruang vertikal terbatas—misalnya pada layar berukuran kecil atau ketika *keyboard* virtual muncul menutupi separuh layar. Tanpa `SingleChildScrollView`, kolom terbawah atau tombol Simpan berisiko terpotong dan memicu error *RenderFlex overflow*. Tombol Simpan sendiri diletakkan di bagian paling bawah `Column` dengan balutan `Align` dan `Padding` agar mudah dijangkau setelah pengguna selesai mengisi seluruh data.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()`**

   `GlobalKey<FormState>` (`_formKey`) bertindak sebagai pengenal unik yang menghubungkan kode di luar formulir (seperti tombol Simpan) dengan state internal milik widget `Form`. Melalui kunci ini, tombol Simpan dapat memicu `_formKey.currentState!.validate()` untuk mengecek seluruh input sekaligus, atau melakukan `reset()` setelah data diproses.

   Setiap `TextFormField` dilengkapi fungsi `validator` yang bertugas memeriksa keabsahan isi kolom. Jika tidak memenuhi syarat, fungsi ini mengembalikan pesan kesalahan (String) yang otomatis muncul di bawah kolom terkait; jika valid, ia mengembalikan `null`. Dialog ringkasan hanya akan ditampilkan apabila seluruh `validator` mengembalikan `null`.

   - **Contoh nilai yang ditolak:** Input nama sertifikat yang hanya berisi spasi kosong (ditolak oleh pengecekan `.trim().isEmpty`), input nama dengan panjang kurang dari 3 karakter seperti `"ab"`, serta input tautan kredensial yang tidak diawali format URL `http://` atau `https://` seperti `"abc"`.
   - **Mengapa konfigurasi input saja tidak cukup:** Mengatur `keyboardType: TextInputType.url` hanya menyesuaikan tata letak tombol pada keyboard perangkat, tetapi tidak mencegah pengguna menempelkan (*paste*) teks acak yang bukan tautan. Begitu pula pembatasan `lastDate` pada kalender `showDatePicker` yang hanya membatasi antarmuka pemilih tanggal. Oleh karena itu, logika validasi di dalam `validator` tetap krusial sebagai lapisan pengaman terakhir sebelum data diproses.

### AI Disclosure: Tutorial 09 dan Individual Assignment 8

#### Bagian yang Dibantu AI

- Membantu merancang struktur direktori proyek dan urutan langkah pengerjaan bertahap, serta menjelaskan konsep dasar widget Flutter seperti model `ItemHomepage`.
- Melakukan pengecekan ulang terhadap riwayat *commit* di GitHub untuk memastikan tidak ada kesalahan sintaks atau *import* yang tertinggal.
- Membantu menyusun kerangka awal untuk jawaban reflektif Tugas 8 dan dokumentasi README sebelum saya sunting kembali.

#### Bagian yang Saya Kerjakan Sendiri

- Menyusun kerangka awal dan kode implementasi untuk file `left_drawer.dart`, `project_form.dart`, `certification_form.dart`, `project_card.dart`, serta penyesuaian pada `menu.dart` dan `main.dart` berdasarkan spesifikasi modul Tutorial 09 dan kriteria Individual Assignment 8.
- Menyiapkan struktur folder dan file secara lokal di VS Code, mengintegrasikan kode, serta menjalankan pengujian fungsional di Google Chrome (menguji alur navigasi kartu dan drawer, menguji kasus validasi input salah/kosong, memverifikasi dialog ringkasan, dan mengecek responsivitas tampilan layar).
- Melakukan *debugging* dan perbaikan mandiri atas beberapa kendala teknis di lingkungan lokal, seperti memperbaiki kesalahan sintaks (kekurangan tanda koma dan kurung pada daftar `items`), memindahkan file `project_form.dart` ke direktori `lib/screens/` yang tepat, serta menghapus file duplikat `project_card.dart` yang sempat salah lokasi.
- Mengarahkan ulang AI ketika struktur kode yang dihasilkan belum sesuai dengan konvensi pada PDF tutorial, serta menyunting ulang teks dokumentasi dan jawaban analisis agar sesuai dengan pemahaman dan hasil implementasi aktual di aplikasi saya.
- Menjalankan pemeriksaan kualitas kode melalui `flutter analyze`, mengelola siklus Git (`add`, `commit`, `push`), dan melakukan pengumpulan tugas ke SCELE.

#### Strategi Prompting

Saya menggunakan pendekatan bertahap dengan mengunggah dokumen PDF tutorial dan instruksi tugas sebagai konteks utama agar AI memahami batasan proyek. Setiap kali muncul error saat kompilasi atau tampilan tidak sesuai harapan, saya melampirkan potongan pesan error dari terminal atau *screenshot* untuk dianalisis bersama. Jika struktur kode yang diberikan AI berbeda dari contoh modul, saya memberikan instruksi koreksi spesifik agar AI menyesuaikan kodenya kembali.

#### AI Chat / Prompting Log

1. **Konteks:** Memulai pengerjaan Individual Assignment 8 setelah menyelesaikan Tutorial 09.

   > Setelah menyelesaikan Tutorial 09, bantu saya merancang form untuk halaman 'Tambah Certification' sesuai ketentuan Individual Assignment 8. Buat daftar 4 field input yang relevan beserta validasinya.

   **Hasilnya:** AI menyusun rancangan formulir dengan 4 field input (nama sertifikat, penerbit, tanggal diperoleh, dan tautan kredensial) beserta logika validasinya.

2. **Konteks:** Memahami hubungan antara class model data dan widget tampilan tombol di halaman utama.

   > Tolong jelaskan konsep dan fungsi dari class model `ItemHomepage`, serta bagaimana perbedaannya dengan widget `ItemCard` dalam menampilkan tombol di halaman utama.

   **Hasilnya:** AI menjelaskan pemisahan tanggung jawab antara `ItemHomepage` sebagai struktur pembawa data (nama, ikon, warna) dan `ItemCard` sebagai komponen UI yang merender tampilan kartu tersebut.

3. **Konteks:** Menyesuaikan logika perpindahan halaman agar mengikuti standar pada modul tutorial.

   > Sesuaikan kode navigasi pada file `menu.dart` agar mengikuti struktur contoh di PDF Tutorial 09, sekaligus memenuhi kriteria Individual Assignment 8 dengan menambahkan percabangan `if-else` pada `ItemCard`.

   **Hasilnya:** AI memperbarui struktur `menu.dart` dan `project_card.dart` dengan menempatkan logika percabangan navigasi `if (item.name == ...)` langsung di dalam `ItemCard`.

#### Keterbatasan AI dan Catatan

- **Keterbatasan Konteks Lingkungan Lokal:** AI tidak memiliki akses untuk menjalankan atau menguji kode secara langsung di perangkat saya. Beberapa kali AI memberikan urutan langkah yang kurang tepat—seperti meminta saya menyambungkan navigasi ke `ProjectFormPage` sebelum file halamannya dibuat sehingga memicu error kompilasi, serta menyertakan karakter ekstra pada perintah terminal yang membuat perintah gagal dieksekusi. Seluruh kode baru tervalidasi sepenuhnya setelah saya jalankan di Chrome dan lolos pemeriksaan `flutter analyze`.
- **Manajemen Struktur Berkas:** Saat proses *refactoring* direktori ke folder `screens` dan `widgets`, sempat terjadi duplikasi file `project_card.dart` dan kesalahan penempatan `project_form.dart` akibat perbedaan instruksi di tengah sesi chat. Kendala ini saya deteksi melalui panel *Problems* di VS Code dan saya rapikan secara manual.
- **Keterbatasan Penyimpanan Data:** Sesuai ruang lingkup tugas saat ini, data yang diinput melalui formulir sertifikat belum terhubung ke *backend* Django maupun penyimpanan lokal persisten, sehingga data baru belum otomatis bertambah ke daftar pada menu "Lihat Certification".
- **Peran Penyuntingan Akhir:** Meskipun AI membantu mempercepat pembuatan kerangka kode dan draf penjelasan awal, saya tetap melakukan peninjauan ulang, pengujian fungsional di peramban, serta penyesuaian redaksi pada jawaban reflektif agar akurat dengan perilaku kode yang saya jalankan.

---

## Tutorial 10 dan Individual Assignment 9

> **Catatan:** Bagian *"Fitur Saat Ini"* dan *"Cara Menjalankan (Setup)"* di bagian atas README ditulis pada tahap awal pengembangan sehingga sudah tidak lengkap. Aplikasi saat ini sudah terintegrasi penuh dengan *backend* Django. Panduan menjalankan versi terbaru ada pada bagian **Setup Terbaru** di bawah ini.

### Progres

**Tutorial 10:** Menyambungkan aplikasi Flutter ke backend Django (`myportofolio`) lewat REST API. Di sisi Django saya menambahkan `TokenAuthentication` (endpoint `/api/v1/auth/token/` untuk login dan `/api/v1/auth/logout/` untuk logout) dan CORS. Di sisi Flutter saya menambahkan model `Certification` dengan `json_serializable`, `ApiClient`, layar daftar dan detail sertifikat, login memakai token (`AuthState` lewat `provider`), dan CI GitHub Actions. Tutorial memakai entitas `Project`, tetapi API saya berisi sertifikat (`/api/v1/certifications/`), jadi saya memakai `Certification`.

**Individual Assignment 9:**
- Model `Certification` (`lib/models/certification.dart`) dengan `@JsonSerializable(fieldRename: FieldRename.snake)`. File `certification.g.dart` dibuat oleh `build_runner`, tidak ikut di Git.
- `ApiClient` (`lib/services/api_client.dart`): `GET /api/v1/certifications/` (publik), lalu `POST`, `PATCH`, dan `DELETE` dengan header `Authorization: Token <key>`. Error server atau jaringan dilempar sebagai `ApiException`.
- Layar daftar sertifikat (`FutureBuilder`, `RefreshIndicator`, tombol Retry, dan tampilan kosong) dan layar detail yang menampilkan semua field.
- Layar daftar bisa dibuka dari kartu "Lihat Certification" di beranda dan dari drawer.
- Form "Tambah Certification" sekarang mengirim data ke server. Sebelum mengirim, form memanggil `ensureLoggedIn(context)` (membuka layar login kalau belum login). Kalau server membalas 401, sesi dibersihkan dan pengguna diminta login lagi. Pesan error lain ditampilkan lewat `SnackBar`.
- Fitur tambahan di luar checklist: **edit dan hapus sertifikat**. Layar detail punya tombol pensil (membuka form yang sama dalam mode edit, dikirim lewat `PATCH`) dan tombol tempat sampah (dialog konfirmasi dengan kolom password form, dikirim lewat `DELETE`). Keduanya butuh login sebagai superuser dan password form yang benar, sama seperti tambah data.
- Tampilan beranda dibuat responsif dan bisa di-scroll: 4 kartu menu sebaris di layar lebar (laptop) dan 2 kartu di atas, 2 di bawah di layar sempit (HP), supaya tidak overflow di berbagai ukuran jendela.
- Git: setiap fitur dikerjakan di branch sendiri (`feat/backend-integration`, `feat/edit-delete-certification`) lalu digabung lewat Pull Request, dengan pesan commit gaya Conventional Commits. File `*.g.dart` dikecualikan lewat `.gitignore` dan `analysis_options.yaml`.
- CI di `.github/workflows/main.yaml` dengan job `build` dan `build_apk`.
- Tes otomatis di folder `test/`: 9 tes, yaitu 2 tes model dan 7 tes `ApiClient` memakai `MockClient` (GET daftar, GET error 500, POST dengan token dan password, POST 401, PATCH, DELETE sukses 204, dan DELETE dengan password salah 400).

Perubahan form dibanding Individual Assignment 8:
- Kolom "Tautan Kredensial" saya ubah menjadi "ID Kredensial" (opsional, maksimal 100 karakter) karena kolom di Django bernama `credential_id` dengan panjang maksimal 100.
- Ada kolom baru "Password Form", karena endpoint tambah, ubah, dan hapus data di Django meminta password form (`FORM_PASSWORD`) selain login sebagai superuser.

**Struktur kode terbaru:**
- `lib/config.dart`: `apiBaseUrl` dari `--dart-define=API_BASE_URL`.
- `lib/models/certification.dart`: model data.
- `lib/services/api_client.dart` dan `lib/services/auth_state.dart`: akses API dan status login.
- `lib/screens/`: `menu.dart`, `certification_list_screen.dart`, `certification_detail_screen.dart`, `certification_form.dart`, `login_screen.dart`, `project_form.dart`.
- `lib/widgets/`: `left_drawer.dart`, `project_card.dart`, `auth_guard.dart`.

### Setup Terbaru

Backend yang sudah deploy: https://debora-putri-myportofolio.pws.cs.ui.ac.id

Repositori backend Django: https://github.com/deboraputridionsimamora/myportofolio

1. Clone repositori dan ambil dependensi:

```bash
git clone [https://github.com/deboraputridionsimamora/myportofolio_mobile.git](https://github.com/deboraputridionsimamora/myportofolio_mobile.git)
cd myportofolio_mobile
flutter pub get
```

2. Buat file hasil generate (`certification.g.dart`). File ini tidak ada di Git, jadi wajib dijalankan setelah clone dan setiap model berubah:

```bash
dart run build_runner build
```

3. Jalankan aplikasi. Alamat backend diatur lewat `--dart-define=API_BASE_URL`:

```bash
# Chrome + Django lokal (python manage.py runserver)
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000

# Emulator Android + Django lokal (alamat bawaan [http://10.0.2.2:8000](http://10.0.2.2:8000), tidak perlu flag)
flutter run

# Backend yang sudah deploy
flutter run -d chrome --dart-define=API_BASE_URL=[https://debora-putri-myportofolio.pws.cs.ui.ac.id](https://debora-putri-myportofolio.pws.cs.ui.ac.id)
```

4. Cek kualitas kode (sama dengan yang dicek CI):

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Untuk menambah, mengubah, atau menghapus sertifikat dari aplikasi dibutuhkan akun superuser di backend dan password form (`FORM_PASSWORD`) milik backend itu. Melihat daftar dan detail sertifikat tidak butuh login.

CI memakai Flutter 3.47.9 (dikunci di `main.yaml`), sama dengan versi di laptop saya.

### Assignment 9

1. **Kenapa memakai `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)`, bukan `Map<String, dynamic>` mentah dari widget? Satu bug yang dicegah.**

   JSON dari Django memakai `snake_case` (`issue_date`, `credential_id`, `star_count`), sedangkan Dart memakai `camelCase` (`issueDate`). Dengan `fieldRename: FieldRename.snake`, `build_runner` membuat kode konversinya dua arah, jadi saya tidak menulis kunci seperti `json['issue_date']` satu per satu. Model juga bertipe: `issueDate` adalah parameter `required`, sehingga kalau lupa diisi, Dart menolaknya saat kompilasi.

   `@JsonKey(includeToJson: false)` saya pasang di `id`, `starCount`, `isStarred`, dan `starredByNames`. Field itu dibuat dan dihitung oleh server, jadi tidak perlu dikirim balik saat `POST`. Dengan begitu `toJson()` hanya berisi field yang memang diterima server.

   Dengan `Map` mentah, kunci diketik manual. Salah ketik seperti `'issuedate'` tetap bisa dikompilasi, lalu baru ketahuan saat server membalas 400 karena `issue_date` kosong.

   Satu bug yang dicegah: error karena nilai `null`. Di model Django saya, `credential_id`, `description`, dan `image` boleh `null`. Kalau saya membaca `json['description'] as String` dari `Map` mentah, sertifikat yang deskripsinya kosong akan melempar `TypeError` saat daftar dimuat. Di model, `@JsonKey(defaultValue: '')` mengubah `null` menjadi string kosong. Perilaku ini saya cek di `test/certification_test.dart`.

2. **Kenapa `Future` untuk `FutureBuilder` dibuat di `initState`, bukan di `build()`? Kenapa `ApiClient` melempar `ApiException`, bukan mengembalikan `null` saat respons bukan 2xx?**

   Method `build()` dipanggil ulang setiap kali widget digambar ulang (`setState`, drawer dibuka, layar diputar, keyboard muncul). Kalau `future: api.getCertifications()` ditulis di dalam `build()`, setiap gambar ulang membuat request baru, `FutureBuilder` kembali ke loading, dan tampilan berkedip. Dengan menyimpan `Future` di field `_future` yang dibuat sekali di `initState`, request hanya jalan sekali. Request baru dibuat dengan sengaja saat Retry atau tarik-untuk-refresh, yaitu dengan mengganti `_future` di dalam `setState`.

   `ApiClient` melempar `ApiException` karena `null` tidak memberi tahu penyebabnya. Server mati, token ditolak (401), validasi gagal (400, misalnya password form salah), dan server error (500) butuh penanganan yang berbeda. `ApiException` membawa pesan dan `statusCode`, sehingga layar bisa menampilkan pesan yang tepat, dan form bisa mengenali 401 lalu mengeluarkan pengguna dan meminta login lagi. `null` juga mudah tertukar dengan "data kosong", dan kesalahan jadi tidak kelihatan. Dengan exception, `FutureBuilder` menerima `snapshot.hasError` dan menampilkan tombol Retry.

3. **`SessionAuthentication` vs `TokenAuthentication`. Kenapa aplikasi mobile memakai Token padahal Django tetap memakai Session?**

   `SessionAuthentication`: pengguna login lewat form di website, server menyimpan sesi, dan browser otomatis mengirim cookie `sessionid` di setiap request. Untuk request yang mengubah data, Django juga meminta CSRF token. Cara ini cocok untuk browser.

   `TokenAuthentication`: klien mengirim username dan password ke `/api/v1/auth/token/`, lalu menerima string token. Token disimpan di `AuthState` dan dikirim di header `Authorization: Token <key>` pada tiap request. Tidak ada cookie dan tidak ada CSRF. Logout menghapus token di server lewat `/api/v1/auth/logout/`.

   Aplikasi mobile memakai Token karena klien `http` di Flutter tidak punya alur cookie dan CSRF seperti browser, dan token yang dikirim lewat header lebih eksplisit. Django tetap memakai Session karena website portofolio saya masih login lewat sesi. Kalau Session dihapus, website itu rusak. Karena itu keduanya didaftarkan: `DEFAULT_AUTHENTICATION_CLASSES` berisi Token dan Session, dan `@authentication_classes([TokenAuthentication, SessionAuthentication])` saya tulis ulang di tiap view karena dekorator itu menimpa pengaturan default. Token ditaruh pertama, sehingga request tanpa login dibalas 401 (bukan 403).

4. **Peran job `build` (pengecekan `very_good_workflows`) dan job `build_apk`. Kenapa `*.g.dart` ada di `.gitignore` padahal CI membutuhkannya?**

   Job `build` memakai workflow siap pakai `VeryGoodOpenSource/very_good_workflows` (`flutter_package.yml@v2`). Langkahnya: checkout, memasang Flutter 3.47.9, `flutter pub get`, menjalankan `dart run build_runner build`, cek format (`dart format --set-exit-if-changed lib test`), `flutter analyze`, lalu tes dengan `very_good test`. Tujuannya menangkap kode yang formatnya berantakan, error analisis, atau tes yang gagal setiap kali ada push atau Pull Request.

   Job `build_apk` berjalan hanya kalau `build` lolos (`needs: build`). Job ini membuat APK release dengan `--dart-define=API_BASE_URL` menunjuk ke backend yang sudah deploy, lalu mengunggahnya sebagai artifact `app-release-apk`. Dengan begitu terbukti aplikasinya benar-benar bisa dibangun untuk Android dan ada file APK yang siap dipasang.

   `*.g.dart` ada di `.gitignore` karena itu file hasil generate yang selalu bisa dibuat ulang dari model. Kalau di-commit, riwayat Git penuh perubahan otomatis, mudah konflik, dan bisa tidak sinkron kalau model diubah tanpa menjalankan `build_runner`. CI tidak butuh file itu ada di repo, karena CI membuatnya sendiri (`setup: dart run build_runner build` di job `build`, dan langkah `build_runner` di job `build_apk`). Di laptop, file itu dibuat dengan perintah di bagian Setup.

   Catatan CI: percobaan pertama gagal di langkah Analyze karena `flutter` versi `stable` terbaru di GitHub menandai `import 'package:flutter/material.dart'` sebagai usang, sedangkan Flutter di laptop saya (3.47.9) tidak. Solusinya mengunci `flutter_version: "3.47.9"` di kedua job supaya hasil CI sama dengan di laptop. Ini berarti ada pekerjaan di masa depan: pindah ke `package:material_ui` saat Flutter dinaikkan.

### Keterbatasan

- Token disimpan di memori (`AuthState`), jadi login hilang kalau aplikasi ditutup.
- Layar detail memakai data dari daftar, tidak mengambil ulang dari server.
- Kartu menu "Tambah Proyek" masih formulir lokal dari Tutorial 09 dan belum tersambung ke API.
- Form edit hanya mengubah nama, penerbit, tanggal, dan ID kredensial. Deskripsi dan gambar sertifikat dikirim ulang apa adanya, jadi belum bisa diubah dari aplikasi.
- Edit dan hapus butuh login superuser dan password form, jadi pengguna biasa tidak bisa memakainya.

### AI Disclosure: Tutorial 10 dan Individual Assignment 9

#### Tools yang Dipakai

Claude (Anthropic), lewat satu sesi chat yang sama selama pengerjaan Tutorial 10 dan Individual Assignment 9.

#### Bagian yang Dibantu AI

- Berdiskusi mengenai perancangan arsitektur integrasi REST API antara Django dan Flutter, termasuk pemilihan mekanisme `TokenAuthentication` dan pola *state management* menggunakan `provider`.
- Membantu meninjau kode implementasi pada sisi Django (`settings.py`, `api_urls.py`, `api_views.py`) maupun Flutter (`api_client.dart`, `auth_state.dart`, `certification.dart`, serta halaman UI) ketika terjadi *bug* atau ketidaksesuaian tipe data.
- Memberikan saran penyusunan skenario pengujian otomatis (`MockClient` pada `api_client_test.dart`) serta membantu menelusuri penyebab kegagalan *pipeline* GitHub Actions akibat perbedaan versi Flutter.
- Memberikan masukan perbaikan tata letak beranda (`main.dart` dan `menu.dart`) agar responsif di layar lebar dan sempit.
- Membantu merapikan struktur penulisan dan tata bahasa pada dokumentasi README serta jawaban reflektif agar lebih terorganisir.

#### Bagian yang Saya Kerjakan Sendiri

- Mengimplementasikan kode integrasi pada proyek Django dan Flutter secara langsung di VS Code, menyesuaikan logika dengan skema model `Certification` yang sudah ada di *backend* portofolio saya.
- Menjalankan seluruh siklus pengembangan lokal di laptop: instalasi paket (`flutter pub add`), eksekusi `build_runner`, pemformatan kode (`dart format`), analisis statis (`flutter analyze`), menjalankan *unit test* (`flutter test`), serta migrasi dan pengujian API di Django.
- Mengelola konfigurasi lingkungan rahasia (`.env` untuk `FORM_PASSWORD` dan akun *superuser* lokal), menangani perbaikan galat lokal (seperti berkas yang belum tersimpan dan penyesuaian direktori), serta melakukan *deployment* pembaruan *backend* ke server PWS.
- Mengelola alur kerja Git dan GitHub: melakukan *commit* bertahap pada *branch* terpisah, membuka *Pull Request*, memperbaiki versi Flutter pada berkas `.github/workflows/main.yaml` setelah mengecek log kegagalan CI, dan melakukan *merge* ke *branch* `main`.
- Memilih untuk mengerjakan fitur tambahan edit/hapus (`PATCH`/`DELETE`) dan tes `MockClient` setelah membandingkan opsi kriteria penilaian, serta menguji seluruh skenario secara manual di Chrome (akses publik, login, tambah, edit, hapus sertifikat, penolakan `FORM_PASSWORD` salah, logout, dan simulasi token `401`).

#### Strategi Prompting

Saya menggunakan PDF panduan tutorial dan instruksi tugas sebagai acuan spesifikasi fitur, lalu mengimplementasikan setiap modul secara bertahap. Ketika menemui pesan galat pada terminal, ketidaksesuaian respons API, atau kegagalan pada log GitHub Actions, saya membagikan potongan pesan *error* dan kode terkait kepada AI untuk menganalisis akar penyebabnya bersama dan memverifikasi solusi perbaikannya.

#### AI Chat / Prompting Log

1. **Konteks:** Mengatasi kendala lupa kredensial akun *superuser* lokal saat menguji fitur login.

   > Saya lupa kredensial akun superuser di database SQLite lokal proyek Django saya untuk menguji endpoint login. Bagaimana perintah `manage.py` untuk mengecek daftar username yang terdaftar dan mengatur ulang kata sandinya?

   **Hasilnya:** AI memberikan perintah untuk memeriksa daftar pengguna melalui Django *shell* dan mereset kata sandi menggunakan `python manage.py changepassword <username>`.

2. **Konteks:** Mendiagnosis penyebab galat validasi kata sandi formulir meskipun input sudah sesuai.

   > Saat menguji pengiriman data sertifikat dari Flutter ke Django lokal, server mengembalikan respons error karena `FORM_PASSWORD` dianggap tidak valid padahal saya sudah mengubah nilainya di berkas `.env`. Mengapa perubahan tersebut belum terbaca oleh server?

   **Hasilnya:** AI menjelaskan bahwa server pengembangan Django (`runserver`) tidak otomatis memuat ulang perubahan pada berkas `.env` di memori, sehingga server perlu dihentikan dan dijalankan ulang agar nilai variabel lingkungan terbaru terbaca.

3. **Konteks:** Memastikan kelengkapan perubahan kode sebelum melanjutkan ke tahap integrasi login.

   > Tolong tinjau daftar perubahan dan riwayat commit lokal saya berikut ini. Apakah seluruh perubahan untuk fitur formulir sertifikat sudah tercatat dengan rapi sebelum saya melanjutkan ke implementasi modul login?

   **Hasilnya:** AI memeriksa log Git yang dilampirkan dan mengonfirmasi bahwa perubahan formulir sudah tercatat, sementara modul autentikasi login masih berada di *working directory* dan siap untuk di-*commit* secara terpisah.

4. **Konteks:** Menganalisis kegagalan *pipeline* CI GitHub Actions pada tahap analisis statis.

   > Pipeline GitHub Actions saya gagal pada langkah `flutter analyze` dengan peringatan bahwa `import 'package:flutter/material.dart'` dianggap usang, padahal perintah yang sama berjalan tanpa peringatan di laptop saya. Mengapa hal ini terjadi dan bagaimana cara mengatasinya di konfigurasi workflow?

   **Hasilnya:** AI mengidentifikasi perbedaan versi SDK antara runner GitHub Actions (yang menggunakan rilis `stable` terbaru) dengan versi lokal saya (`3.47.9`), serta menyarankan penguncian `flutter_version: "3.47.9"` pada berkas `.github/workflows/main.yaml`.

5. **Konteks:** Membandingkan opsi fitur tambahan pada Individual Assignment 9 sebelum memutuskan cakupan pengerjaan.

   > Saya ingin mempertimbangkan untuk mengerjakan kedua opsi fitur tambahan pada Individual Assignment 9 (implementasi endpoint `PATCH`/`DELETE` serta pengujian unit menggunakan `MockClient`). Tolong jelaskan perbedaan bobot kriteria penilaian dan dampak kompleksitas implementasi dari masing-masing opsi tersebut agar saya bisa merencanakan pengerjaannya dengan tepat.

   **Hasilnya:** AI menjabarkan perbandingan cakupan teknis dan kriteria penilaian dari kedua opsi tersebut, sehingga saya memutuskan untuk mengimplementasikan keduanya secara bertahap.

6. **Konteks:** Menangani tampilan *banner* `DEBUG` dan memperbaiki tata letak kartu menu agar responsif di berbagai ukuran layar Chrome.

   > Saat saya menguji tampilan di Chrome, muncul pita label `DEBUG` di pojok kanan atas dan susunan 4 kartu menu di halaman utama terpotong saat jendela diperbesar atau diperkecil. Bagaimana cara menyembunyikan *banner* tersebut dan membuat tata letak kartu menyesuaikan ukuran layar—misalnya menjadi *grid* 2x2 yang bisa di-scroll?

   **Hasilnya:** AI menjelaskan bahwa pita tersebut berasal dari properti `debugShowCheckedModeBanner` pada mode pengembangan, lalu menyarankan penggunaan `SingleChildScrollView` dengan tata letak responsif di `menu.dart` (4 kolom di layar lebar dan 2 kolom di layar sempit) agar tampilan tidak *overflow*.

#### Keterbatasan AI dan Catatan

- AI tidak dapat menjalankan atau menguji aplikasi Flutter di lingkungan lokal saya secara langsung, sehingga seluruh kode baru tervalidasi sepenuhnya setelah saya jalankan sendiri di Chrome serta melewati pemeriksaan `flutter analyze`, `flutter test`, dan CI GitHub Actions.
- Beberapa saran perintah atau konfigurasi dari AI sempat tidak sesuai dengan lingkungan saya—seperti penggunaan opsi `--delete-conflicting-outputs` pada `build_runner` yang memicu peringatan di versi SDK saya, serta perbedaan versi Flutter `stable` di *runner* CI hingga saya menguncinya ke `3.47.9`.
- Setelah `TokenAuthentication` ditempatkan di urutan pertama pada pengaturan autentikasi Django, kode status respons untuk permintaan tanpa kredensial berubah dari `403 Forbidden` menjadi `401 Unauthorized`, sehingga saya perlu menyesuaikan tiga asersi pada `tests_api.py` di sisi Django.
- Penyesuaian kolom formulir dari "Tautan Kredensial" menjadi "ID Kredensial" dilakukan agar selaras dengan skema kolom `credential_id` pada model Django yang sudah ada, sementara draf jawaban reflektif tetap saya tinjau dan sesuaikan ulang dengan perilaku aktual kode saya.