import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/certification.dart';

/// Error dari server atau jaringan. Dilempar biar layar bisa nampilin pesannya,
/// bukan balikin null yang bikin kita gak tau kenapa gagal.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Semua urusan ngobrol sama backend Django ada di sini.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  // kalau token ada, ditempel di header Authorization
  Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// GET publik, gak butuh login.
  Future<List<Certification>> getCertifications() async {
    final response = await _send(
      () => _client.get(_uri('/api/v1/certifications/'), headers: _headers()),
    );
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data
          .map((item) => Certification.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ApiException('Format respons server tidak sesuai.');
    } on TypeError {
      throw const ApiException('Format respons server tidak sesuai.');
    }
  }

  /// POST butuh token. "password" itu password form dari Django (FORM_PASSWORD).
  Future<Certification> createCertification(
    Certification certification, {
    required String token,
    required String password,
  }) async {
    final body = jsonEncode({...certification.toJson(), 'password': password});
    final response = await _send(
      () => _client.post(
        _uri('/api/v1/certifications/'),
        headers: _headers(token: token),
        body: body,
      ),
    );
    return _parseCertification(response);
  }

  /// PATCH: ubah sertifikat yang sudah ada. Butuh token dan password form.
  Future<Certification> updateCertification(
    int id,
    Certification certification, {
    required String token,
    required String password,
  }) async {
    final body = jsonEncode({...certification.toJson(), 'password': password});
    final response = await _send(
      () => _client.patch(
        _uri('/api/v1/certifications/$id/'),
        headers: _headers(token: token),
        body: body,
      ),
    );
    return _parseCertification(response);
  }

  /// DELETE: hapus sertifikat. Butuh token dan password form.
  /// Server balas 204 (tanpa isi), jadi gak ada yang dikembalikan.
  Future<void> deleteCertification(
    int id, {
    required String token,
    required String password,
  }) async {
    await _send(
      () => _client.delete(
        _uri('/api/v1/certifications/$id/'),
        headers: _headers(token: token),
        body: jsonEncode({'password': password}),
      ),
    );
  }

  /// Login: tukar username + password dengan token.
  Future<String> obtainToken(String username, String password) async {
    try {
      final response = await _send(
        () => _client.post(
          _uri('/api/v1/auth/token/'),
          headers: _headers(),
          body: jsonEncode({'username': username, 'password': password}),
        ),
      );
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data as Map<String, dynamic>)['token'] as String;
    } on ApiException catch (e) {
      // DRF balikin 400 kalau username/password salah
      if (e.statusCode == 400) {
        throw const ApiException(
          'Username atau password salah.',
          statusCode: 400,
        );
      }
      rethrow;
    } on FormatException {
      throw const ApiException('Format respons server tidak sesuai.');
    } on TypeError {
      throw const ApiException('Format respons server tidak sesuai.');
    }
  }

  /// Logout: token dihapus di server.
  Future<void> logout(String token) async {
    await _send(
      () => _client.post(
        _uri('/api/v1/auth/logout/'),
        headers: _headers(token: token),
      ),
    );
  }

  void close() => _client.close();

  // ubah isi respons jadi satu objek Certification
  Certification _parseCertification(http.Response response) {
    try {
      return Certification.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );
    } on FormatException {
      throw const ApiException('Format respons server tidak sesuai.');
    } on TypeError {
      throw const ApiException('Format respons server tidak sesuai.');
    }
  }

  // jalanin request, ubah error jaringan jadi ApiException
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException('Server tidak merespons, coba lagi nanti.');
    } on http.ClientException {
      throw const ApiException(
        'Gagal terhubung ke server. Cek internet atau alamat API.',
      );
    }
    return _ensureSuccess(response);
  }

  // kode 2xx lolos, selain itu dilempar sebagai ApiException
  http.Response _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    throw ApiException(
      _errorMessage(response),
      statusCode: response.statusCode,
    );
  }

  String _errorMessage(http.Response response) {
    if (response.statusCode == 401) {
      return 'Sesi login habis, silakan login lagi.';
    }
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map<String, dynamic>) {
        final detail = body['detail'];
        if (detail is String) return detail;
        // error validasi DRF bentuknya {"field": ["pesan", ...]}
        final messages = body.entries.map((entry) {
          final value = entry.value;
          final text = value is List ? value.join(', ') : '$value';
          return '${entry.key}: $text';
        });
        if (messages.isNotEmpty) return messages.join('\n');
      }
    } on FormatException {
      // body bukan JSON (misal halaman error HTML), pakai pesan umum di bawah
    }
    return 'Terjadi kesalahan di server (kode ${response.statusCode}).';
  }
}
