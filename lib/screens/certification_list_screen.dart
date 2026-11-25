import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certification.dart';
import 'package:myportofolio_mobile/screens/certification_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Daftar sertifikat yang diambil dari backend Django.
class CertificationListScreen extends StatefulWidget {
  const CertificationListScreen({super.key});

  @override
  State<CertificationListScreen> createState() =>
      _CertificationListScreenState();
}

class _CertificationListScreenState extends State<CertificationListScreen> {
  late final ApiClient _api;

  // Future disimpan di state dan dibuat di initState, bukan di build().
  // Kalau dibuat di build(), tiap layar digambar ulang request-nya ikut ngulang.
  late Future<List<Certification>> _future;

  @override
  void initState() {
    super.initState();
    _api = context.read<ApiClient>();
    _future = _api.getCertifications();
  }

  // dipanggil pas tombol Retry ditekan
  void _retry() {
    setState(() {
      _future = _api.getCertifications();
    });
  }

  // dipanggil pas layar ditarik ke bawah (pull to refresh)
  Future<void> _refresh() async {
    final next = _api.getCertifications();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } on ApiException {
      // errornya ditampilkan sama FutureBuilder, jadi di sini diabaikan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Certifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Certification>>(
          future: _future,
          builder: (context, snapshot) {
            // 1. masih loading
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. gagal: tampilkan pesan dan tombol Retry
            final error = snapshot.error;
            if (error != null) {
              final message = error is ApiException
                  ? error.message
                  : 'Terjadi kesalahan tak terduga.';
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 12),
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. berhasil tapi datanya kosong
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              // pakai ListView biar tetap bisa ditarik buat refresh
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Belum ada sertifikat.')),
                ],
              );
            }

            // 4. berhasil dan ada datanya
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final cert = items[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.workspace_premium),
                    title: Text(cert.title),
                    subtitle: Text('${cert.issuer}\n${cert.issueDate}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 18),
                        const SizedBox(width: 4),
                        Text('${cert.starCount}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CertificationDetailScreen(certification: cert),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
