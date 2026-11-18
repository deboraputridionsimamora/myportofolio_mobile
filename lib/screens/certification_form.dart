import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman form buat nambah sertifikat baru ke portofolio.
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
  String _credentialUrl = "";

  // controller biar teks di kolom tanggal bisa diisi dari date picker
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    // controller harus dibuang kalau halamannya ditutup
    _dateController.dispose();
    super.dispose();
  }

  // ubah DateTime jadi teks dd/mm/yyyy
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
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

  // tampilkan ringkasan isian dalam dialog
  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sertifikat berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: $_title'),
                Text('Penerbit: $_issuer'),
                Text('Tanggal: ${_formatDate(_issueDate!)}'),
                // kalau tautan dikosongin, tampilkan strip
                Text(
                  'Tautan: ${_credentialUrl.trim().isEmpty ? "-" : _credentialUrl.trim()}',
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
                _formKey.currentState!.reset();
                setState(() {
                  _title = "";
                  _issuer = "";
                  _issueDate = null;
                  _credentialUrl = "";
                  _dateController.clear();
                });
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

              // === Tautan Kredensial (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://... (opsional)",
                    labelText: "Tautan Kredensial",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _credentialUrl = value!;
                    });
                  },
                  validator: (String? value) {
                    final text = value?.trim() ?? "";
                    // kosong boleh, karena opsional
                    if (text.isEmpty) {
                      return null;
                    }
                    final uri = Uri.tryParse(text);
                    final valid =
                        uri != null &&
                        (uri.scheme == 'http' || uri.scheme == 'https') &&
                        uri.host.isNotEmpty;
                    if (!valid) {
                      return "Format URL tidak valid (harus diawali http:// atau https://)";
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
                    onPressed: () {
                      // cek semua field, dialog cuma muncul kalau semuanya valid
                      if (_formKey.currentState!.validate()) {
                        _showSummaryDialog();
                      }
                    },
                    child: const Text(
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
