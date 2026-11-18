import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Kartu tombol menu. Kalau ditekan muncul SnackBar, lalu pindah halaman kalau tombolnya perlu.
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
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // pindah ke halaman yang sesuai, dicek lewat nama tombolnya
          if (item.name == "Tambah Proyek") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          } else if (item.name == "Tambah Certification") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CertificationFormPage(),
              ),
            );
          }

          // kalau tombol ini punya aksi tambahan (misal dialog sertifikat), jalankan juga
          item.onTap?.call(context);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
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
