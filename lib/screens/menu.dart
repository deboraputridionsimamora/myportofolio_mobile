import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

/// Halaman menu utama aplikasi. Pakai StatelessWidget karena tampilannya tetap.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // data pemilik portofolio
  final String npm = "2506544126";
  final String nama = "Debora Putri Dion Simamora";
  final String kelas = "PBP A";

  // daftar tombol menu, tiap tombol punya warna sendiri
  // pindah halaman dikerjain di ItemCard (project_card.dart)
  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Certification", Icons.workspace_premium, Colors.blue),
    ItemHomepage("Tambah Certification", Icons.add_circle, Colors.green),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.orange),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      // SingleChildScrollView biar halaman bisa di-scroll kalau layarnya pendek
      body: SingleChildScrollView(
        // Center + ConstrainedBox biar isinya gak melebar banget di layar besar
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // baris horizontal buat 3 InfoCard sejajar, tiap kartu dapet lebar sama
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InfoCard(title: 'NPM', content: npm),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Name', content: nama),
                      ),
                      Expanded(
                        child: InfoCard(title: 'Class', content: kelas),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // bagian tengah: tulisan sambutan dan kotak-kotak tombol menu
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

                  // GridView 2 kolom: 4 tombol jadi 2 di atas dan 2 di bawah
                  GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    // kartu dibuat agak lebar (bukan kotak) biar gak terlalu tinggi
                    childAspectRatio: 1.5,
                    // shrinkWrap biar tinggi grid ngikutin isinya
                    shrinkWrap: true,
                    // scroll-nya diserahin ke SingleChildScrollView di atas
                    physics: const NeverScrollableScrollPhysics(),
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
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
        // lebarnya ngikutin Expanded dari Row di atas
        padding: const EdgeInsets.all(16.0),
        // susun teks title dan content ke bawah
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
