import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Nyimpen status login (token dan username).
/// Disimpan di memori aja, jadi hilang kalau aplikasinya ditutup.
class AuthState extends ChangeNotifier {
  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;
  bool get isLoggedIn => _token != null;

  /// Login: tukar username + password dengan token dari server.
  Future<void> login(ApiClient api, String username, String password) async {
    final token = await api.obtainToken(username, password);
    _token = token;
    _username = username;
    notifyListeners();
  }

  /// Logout: minta server hapus token. Kalau gagal (misal offline),
  /// sesi di HP tetap dibersihkan.
  Future<void> logout(ApiClient api) async {
    final token = _token;
    try {
      if (token != null) {
        await api.logout(token);
      }
    } on ApiException {
      // gagal hubungi server gak apa-apa, sesi lokal tetap dihapus di bawah
    } finally {
      clearSession();
    }
  }

  /// Hapus token dan username. Dipanggil juga pas server balas 401.
  void clearSession() {
    _token = null;
    _username = null;
    notifyListeners();
  }
}
