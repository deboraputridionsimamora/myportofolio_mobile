import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certification.dart';
import 'package:myportofolio_mobile/screens/certification_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Halaman form buat nambah sertifikat baru, datanya dikirim ke backend Django.
class CertificationFormPage extends StatefulWidget {
  const CertificationFormPage({super.key});

  @override
  State<CertificationFormPage> createState() => _CertificationFormPageState();
}

class _CertificationFormPageState extends State<CertificationFormPage> {
  // kunci form, dipakai buat validate() dan reset()
  final _formKey = GlobalKey<FormState>();

  // variabel buat nyimpen isi tiap field
  String _title = "";
  String _issuer = "";
  DateTime? _issueDate;
  String _credentialId = "";
  String _password = "";

  // true selama data lagi dikirim ke server, buat nonaktifin tombol
  bool _submitting = false;

  // controller biar teks di kolom tanggal bisa diisi dari date picker
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    // controller harus dibuang kalau halamannya ditutup
    _dateController.dispose();
    super.dispose();
  }

  // ubah DateTime jadi teks dd/mm/yyyy buat ditampilkan ke user
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  // ubah DateTime jadi yyyy-mm-dd, format yang dimau DateField Django
  String _formatApiDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  // buka kalender, hasilnya disimpan ke _issueDate
  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _issueDate ?? now,
      firstDate: DateTime(1990),
      // lastDate = hari ini, jadi tanggal masa depan gak bisa dipilih
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _issueDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // kosongin semua isian form
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _issuer = "";
      _issueDate = null;
      _credentialId = "";
      _password = "";
      _dateController.clear();
    });
  }

  // dipanggil pas tombol Simpan ditekan
  Future<void> _submit() async {
    // 1. cek semua field dulu
    if (!_formKey.currentState!.validate()) return;

    // 2. harus login dulu, kalau belum akan dibuka halaman login
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _submitting = true;
    });

    try {
      // 3. kirim ke server pakai token
      final created = await api.createCertification(
        Certification(
          title: _title.trim(),
          issuer: _issuer.trim(),
          issueDate: _formatApiDate(_issueDate!),
          credentialId: _credentialId.trim(),
        ),
        token: auth.token!,
        password: _password,
      );
      if (!mounted) return;
      setState(() {
        _submitting = false;
      });
      _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
      });
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));

      // 401 = token udah gak berlaku: hapus sesi lalu minta login lagi
      if (e.statusCode == 401) {
        auth.clearSession();
        await ensureLoggedIn(context);
      }
    }
  }

  // dialog konfirmasi kalau data sukses disimpan di server
  void _showSuccessDialog(Certification created) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sertifikat berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${created.title}'),
                Text('Penerbit: ${created.issuer}'),
                Text('Tanggal: ${created.issueDate}'),
                // kalau ID kredensial dikosongin, tampilkan strip
                Text(
                  'ID Kredensial: ${created.credentialId.isEmpty ? "-" : created.credentialId}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                // tutup dialog lalu kosongin form lagi
                Navigator.of(dialogContext).pop();
                _resetForm();
              },
            ),
            TextButton(
              child: const Text('Lihat Daftar'),
              onPressed: () {
                // tutup dialog, kosongin form, lalu buka daftar (datanya diambil ulang)
                final navigator = Navigator.of(dialogContext);
                navigator.pop();
                _resetForm();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CertificationListScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar pakai warna tema yang sama kayak halaman utama
      appBar: AppBar(
        title: const Text(
          'Add Certification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // drawer yang sama kayak di halaman lain
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // scroll biar tombol Simpan tetap kejangkau di layar sempit atau pas keyboard muncul
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Sertifikat ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: TOEFL ITP",
                    labelText: "Nama Sertifikat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    final text = value?.trim() ?? "";
                    if (text.isEmpty) {
                      return "Nama sertifikat tidak boleh kosong!";
                    }
                    if (text.length < 3) {
                      return "Nama sertifikat minimal 3 karakter!";
                    }
                    if (text.length > 100) {
                      return "Nama sertifikat maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Penerbit ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Educational Testing Service",
                    labelText: "Penerbit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _issuer = value!;
                    });
                  },
                  validator: (String? value) {
                    final text = value?.trim() ?? "";
                    if (text.isEmpty) {
                      return "Penerbit tidak boleh kosong!";
                    }
                    if (text.length > 100) {
                      return "Penerbit maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Diperoleh (date picker) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dateController,
                  // readOnly biar gak muncul keyboard, isinya dari date picker
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal",
                    labelText: "Tanggal Diperoleh",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (_issueDate == null) {
                      return "Tanggal diperoleh harus dipilih!";
                    }
                    if (_issueDate!.isAfter(DateTime.now())) {
                      return "Tanggal tidak boleh di masa depan!";
                    }
                    return null;
                  },
                ),
              ),

              // === ID Kredensial (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: ABC-12345 (opsional)",
                    labelText: "ID Kredensial",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _credentialId = value!;
                    });
                  },
                  validator: (String? value) {
                    // kosong boleh, tapi maksimal 100 karakter (batas di database)
                    final text = value?.trim() ?? "";
                    if (text.length > 100) {
                      return "ID kredensial maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Password Form (dicek sama Django) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // obscureText biar password tampil sebagai titik-titik
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password form yang sama kayak di website",
                    labelText: "Password Form",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _password = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Password form tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // dinonaktifin selama request jalan biar gak kepencet dua kali
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
