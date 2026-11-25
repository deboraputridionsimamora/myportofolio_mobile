import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certification.dart';

/// Detail satu sertifikat, semua field dari API ditampilkan di sini.
class CertificationDetailScreen extends StatelessWidget {
  const CertificationDetailScreen({super.key, required this.certification});

  final Certification certification;

  @override
  Widget build(BuildContext context) {
    final cert = certification;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Certification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            cert.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(cert.issuer, style: textTheme.titleMedium),
          const Divider(height: 32),
          _DetailRow(
            icon: Icons.event,
            label: 'Tanggal terbit',
            value: cert.issueDate,
          ),
          _DetailRow(
            icon: Icons.badge_outlined,
            label: 'ID kredensial',
            value: cert.credentialId.isEmpty ? '-' : cert.credentialId,
          ),
          _DetailRow(
            icon: Icons.notes,
            label: 'Deskripsi',
            value: cert.description.isEmpty ? '-' : cert.description,
          ),
          _DetailRow(
            icon: Icons.star,
            label: 'Jumlah star',
            value: cert.starCount == 0
                ? '0'
                : '${cert.starCount} (${cert.starredByNames})',
          ),
          // gambar cuma ditampilkan kalau isinya link http/https
          if (cert.image.startsWith('http'))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  cert.image,
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Gambar gagal dimuat.'),
                ),
              ),
            )
          else
            _DetailRow(
              icon: Icons.image_outlined,
              label: 'Gambar',
              value: cert.image.isEmpty ? '-' : cert.image,
            ),
        ],
      ),
    );
  }
}

/// Satu baris detail: ikon, label kecil, lalu isinya.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
