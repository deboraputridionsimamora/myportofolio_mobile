import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/certification.dart';

void main() {
  group('Certification', () {
    test('fromJson baca field snake_case dan isi default kalau null', () {
      final cert = Certification.fromJson({
        'id': 1,
        'title': 'TOEFL ITP',
        'issuer': 'ETS',
        'issue_date': '2024-05-01',
        'credential_id': null,
        'description': null,
        'image': null,
        'star_count': 2,
        'is_starred': true,
        'starred_by_names': 'debora, budi',
      });

      expect(cert.id, 1);
      expect(cert.issueDate, '2024-05-01');
      // field yang null di server diganti string kosong
      expect(cert.credentialId, '');
      expect(cert.description, '');
      expect(cert.image, '');
      expect(cert.starCount, 2);
      expect(cert.isStarred, true);
    });

    test('toJson pakai snake_case dan tidak ngirim id atau field hitungan', () {
      const cert = Certification(
        id: 5,
        title: 'TOEFL ITP',
        issuer: 'ETS',
        issueDate: '2024-05-01',
        credentialId: 'ABC-123',
        starCount: 3,
        isStarred: true,
        starredByNames: 'debora',
      );

      final json = cert.toJson();

      expect(json['issue_date'], '2024-05-01');
      expect(json['credential_id'], 'ABC-123');
      expect(json.containsKey('id'), false);
      expect(json.containsKey('star_count'), false);
      expect(json.containsKey('is_starred'), false);
      expect(json.containsKey('starred_by_names'), false);
    });
  });
}
