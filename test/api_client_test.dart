import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/certification.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  const baseUrl = 'http://test.local';

  // contoh satu sertifikat versi JSON dari server
  final sampleJson = {
    'id': 1,
    'title': 'TOEFL ITP',
    'issuer': 'ETS',
    'issue_date': '2024-05-01',
    'credential_id': 'ABC-123',
    'description': null,
    'image': null,
    'star_count': 0,
    'is_starred': false,
    'starred_by_names': '',
  };

  group('ApiClient', () {
    test('getCertifications ngubah JSON jadi list Certification', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$baseUrl/api/v1/certifications/');
        return http.Response(jsonEncode([sampleJson]), 200);
      });
      final api = ApiClient(client: client, baseUrl: baseUrl);

      final result = await api.getCertifications();

      expect(result, hasLength(1));
      expect(result.first.title, 'TOEFL ITP');
      expect(result.first.description, '');
    });

    test(
      'getCertifications ngelempar ApiException kalau server error',
      () async {
        final client = MockClient(
          (request) async => http.Response('oops', 500),
        );
        final api = ApiClient(client: client, baseUrl: baseUrl);

        await expectLater(
          api.getCertifications(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
          ),
        );
      },
    );

    test('createCertification ngirim token dan password', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Token abc123');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['password'], 'rahasia');
        expect(body['issue_date'], '2024-05-01');
        return http.Response(jsonEncode(sampleJson), 201);
      });
      final api = ApiClient(client: client, baseUrl: baseUrl);

      final created = await api.createCertification(
        const Certification(
          title: 'TOEFL ITP',
          issuer: 'ETS',
          issueDate: '2024-05-01',
        ),
        token: 'abc123',
        password: 'rahasia',
      );

      expect(created.id, 1);
    });

    test(
      'createCertification ngelempar ApiException 401 kalau token ditolak',
      () async {
        final client = MockClient(
          (request) async => http.Response('{"detail":"Invalid token."}', 401),
        );
        final api = ApiClient(client: client, baseUrl: baseUrl);

        await expectLater(
          api.createCertification(
            const Certification(
              title: 'TOEFL ITP',
              issuer: 'ETS',
              issueDate: '2024-05-01',
            ),
            token: 'salah',
            password: 'rahasia',
          ),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
          ),
        );
      },
    );

    test('updateCertification ngirim PATCH ke alamat detail', () async {
      final client = MockClient((request) async {
        expect(request.method, 'PATCH');
        expect(request.url.toString(), '$baseUrl/api/v1/certifications/1/');
        expect(request.headers['Authorization'], 'Token abc123');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'TOEFL iBT');
        expect(body['password'], 'rahasia');
        return http.Response(
          jsonEncode({...sampleJson, 'title': 'TOEFL iBT'}),
          200,
        );
      });
      final api = ApiClient(client: client, baseUrl: baseUrl);

      final updated = await api.updateCertification(
        1,
        const Certification(
          title: 'TOEFL iBT',
          issuer: 'ETS',
          issueDate: '2024-05-01',
        ),
        token: 'abc123',
        password: 'rahasia',
      );

      expect(updated.title, 'TOEFL iBT');
    });

    test('deleteCertification ngirim DELETE dan sukses kalau 204', () async {
      final client = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.toString(), '$baseUrl/api/v1/certifications/1/');
        expect(request.headers['Authorization'], 'Token abc123');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['password'], 'rahasia');
        return http.Response('', 204);
      });
      final api = ApiClient(client: client, baseUrl: baseUrl);

      await api.deleteCertification(1, token: 'abc123', password: 'rahasia');
    });

    test('deleteCertification ngelempar ApiException 400 kalau password form salah', () async {
      final client = MockClient(
        (request) async => http.Response(
          jsonEncode({
            'password': ['Password salah! Perubahan tidak disimpan.'],
          }),
          400,
        ),
      );
      final api = ApiClient(client: client, baseUrl: baseUrl);

      await expectLater(
        api.deleteCertification(1, token: 'abc123', password: 'salah'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.message, 'message', contains('Password salah')),
        ),
      );
    });
  });
}
