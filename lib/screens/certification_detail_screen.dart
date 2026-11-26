import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certification.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Detail satu sertifikat, semua field dari API ditampilkan di sini.
class CertificationDetailScreen extends StatefulWidget {
  const CertificationDetailScreen({super.key, required this.certification});

  final Certification certification;

  @override
  State<CertificationDetailScreen> createState() =>
      _CertificationDetailScreenState();
}

class _CertificationDetailScreenState extends State<CertificationDetailScreen> {
  // data yang lagi ditampilkan, bisa berubah setelah diedit
  late Certification _cert;

  @override
  void initState() {
    super.initState();
    _cert = widget.certification;
  }

  // buka form dalam mode edit, hasilnya sertifikat yang sudah diperbarui
  Future<void> _edit() async {
    final updated = await Navigator.push<Certification>(
      context,
      MaterialPageRoute(
        builder: (context) => CertificationFormPage(certification: _cert),
      ),
    );
    // kalau user batal (updated kosong), tampilan dibiarkan seperti semula
    if (updated != null && mounted) {
      setState(() {
        _cert = updated;
      });
    }
  }

  Future<void> _delete() async {
    final id = _cert.id;
    if (id == null) return;

    // 1. konfirmasi dan minta password form
    final password = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _DeleteDialog(title: _cert.title),
    );
    if (password == null || !mounted) return;

    // 2. harus login dulu
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // 3. kirim DELETE ke server pakai token
      await api.deleteCertification(id, token: auth.token!, password: password);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('"${_cert.title}" berhasil dihapus.')),
        );
      // balik ke daftar, daftarnya otomatis diambil ulang
      navigator.pop();
    } on ApiException catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));

      // 401 = token udah gak berlaku: hapus sesi lalu minta login lagi
      if (e.statusCode == 401) {
        auth.clearSession();
        if (mounted) {
          await ensureLoggedIn(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cert = _cert;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Certification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        // tombol edit dan hapus cuma ada kalau sertifikatnya punya id dari server
        actions: [
          if (cert.id != null) ...[
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit),
              onPressed: _edit,
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete),
              onPressed: _delete,
            ),
          ],
        ],
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

/// Dialog konfirmasi hapus, sekalian minta password form.
/// Dibuat StatefulWidget supaya controller-nya bisa dibuang pas dialog ditutup.
class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog({required this.title});

  final String title;

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_controller.text.isEmpty) {
      setState(() {
        _error = 'Password form tidak boleh kosong!';
      });
      return;
    }
    // password dikirim balik ke yang manggil dialog
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus sertifikat?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${widget.title}" akan dihapus dari server. '
            'Masukkan password form untuk melanjutkan.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Form',
              errorText: _error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(onPressed: _confirm, child: const Text('Hapus')),
      ],
    );
  }
}
