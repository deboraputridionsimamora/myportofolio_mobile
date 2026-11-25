import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Pastiin user udah login sebelum lanjut.
/// Kalau belum, buka halaman login dulu.
/// Hasilnya true kalau akhirnya sudah login, false kalau user batal.
Future<bool> ensureLoggedIn(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (auth.isLoggedIn) return true;

  final navigator = Navigator.of(context);
  final result = await navigator.push<bool>(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return result == true;
}
