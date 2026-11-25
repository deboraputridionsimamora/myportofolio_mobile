import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/screens/certification_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

// menu samping (drawer) buat pindah-pindah halaman
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // watch biar drawer otomatis ganti Login/Logout pas status login berubah
    final auth = context.watch<AuthState>();

    return Drawer(
      child: ListView(
        children: [
          // bagian atas drawer: judul dan deskripsi singkat aplikasi
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          // menu Home: pakai pushReplacement biar halaman lama diganti
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          // menu Lihat Certification: pindah ke daftar sertifikat dari API
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Lihat Certification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CertificationListScreen(),
                ),
              );
            },
          ),
          // menu Add Project: pindah ke halaman form proyek
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
          // menu Add Certification: pindah ke halaman form sertifikat
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: const Text('Add Certification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CertificationFormPage(),
                ),
              );
            },
          ),
          const Divider(),
          // kalau sudah login tampil Logout, kalau belum tampil Login
          if (auth.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout (${auth.username})'),
              onTap: () async {
                final api = context.read<ApiClient>();
                final messenger = ScaffoldMessenger.of(context);
                // tutup drawer dulu
                Navigator.pop(context);
                await auth.logout(api);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Berhasil logout.')),
                );
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
        ],
      ),
    );
  }
}
