import 'package:flutter/material.dart';

/// Halaman menu utama aplikasi. Pakai StatelessWidget karena tampilannya tetap.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // data pemilik portofolio
  final String npm = "2506544126";
  final String nama = "Debora Putri Dion Simamora";
  final String kelas = "PBP A";

  // daftar tombol menu, tiap tombol punya warna sendiri
  // tombol Certification punya aksi tambahan: nampilin dialog daftar sertifikat
  final List<ItemHomepage> items = [
    ItemHomepage(
      "Lihat Certification",
      Icons.workspace_premium,
      Colors.blue,
      onTap: showCertificationDialog,
    ),
    ItemHomepage("Tambah Certification", Icons.add_circle, Colors.green),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold ngasih kerangka halaman (AppBar, body, SnackBar)
    return Scaffold(
      // AppBar = bar di bagian atas halaman
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // body halaman utama, dikasih padding biar gak mepet pinggir
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // baris horizontal buat 3 InfoCard sejajar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),

            const SizedBox(height: 16.0),

            // bagian tengah: tulisan sambutan dan kotak-kotak tombol menu
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Selamat datang di MyPortfolio Mobile!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // GridView buat nampilin kartu tombol dalam bentuk kotak-kotak 3 kolom
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    // shrinkWrap biar tinggi grid ngikutin isinya
                    shrinkWrap: true,
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu informasi kecil (judul + isi), dibuat sekali tapi dipakai 3 kali.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // kasih bayangan tipis
      elevation: 2.0,
      child: Container(
        // lebar kartu menyesuaikan lebar layar (dibagi 3.5)
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        // susun teks title dan content ke bawah
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // textAlign center biar nama yang panjang tetap rapi di tengah
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Model data satu tombol menu: nama, ikon, warna latar, dan aksi tambahan (opsional).
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  // aksi tambahan pas tombol ditekan, boleh kosong (null)
  final void Function(BuildContext context)? onTap;

  ItemHomepage(this.name, this.icon, this.color, {this.onTap});
}

/// Kartu tombol menu. Kalau ditekan muncul SnackBar, dan aksi tambahan kalau ada.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // warna latar diambil dari tiap item biar beda-beda
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // aksi pas kartu ditekan
        onTap: () {
          // munculin SnackBar dengan pesan nama tombol yang ditekan
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
            );
          // kalau tombol ini punya aksi tambahan, jalankan juga
          item.onTap?.call(context);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Model data satu sertifikat (judul dan penerbit).
class CertificationItem {
  final String title;
  final String issuer;

  const CertificationItem(this.title, this.issuer);
}

// daftar sertifikat (samain dengan yang ada di website portofolio Django)
const List<CertificationItem> certifications = [
  CertificationItem("TOEFL ITP", "Educational Testing Service (ETS) Global B.V."),
  CertificationItem(
    "Finalist 9th International Science Olympiad in Mathematics",
    "International Science Olympiad",
  ),
  CertificationItem(
    "Student Council Executive Committee Appreciation Certificate",
    "SMA Negeri 3 Medan",
  ),
  CertificationItem(
    "Uji Kemahiran Berbahasa Indonesia (UKBI)",
    "Badan Pengembangan dan Pembinaan Bahasa",
  ),
  CertificationItem("Super Mentor Staff DDP0 2026", "ARUNG 2025"),
];

/// Nampilin dialog berisi daftar sertifikat.
void showCertificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Licenses & Certifications'),
        content: SizedBox(
          width: double.maxFinite,
          // ListView biar bisa di-scroll kalau sertifikatnya banyak
          child: ListView(
            shrinkWrap: true,
            children: certifications.map((CertificationItem cert) {
              return ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: Text(cert.title),
                subtitle: Text(cert.issuer),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            // tutup dialog
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tutup'),
          ),
        ],
      );
    },
  );
}