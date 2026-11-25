import 'package:json_annotation/json_annotation.dart';

part 'certification.g.dart';

/// Sertifikat portofolio, disamain dengan CertificationSerializer di Django (/api/v1/certifications/).
@JsonSerializable(fieldRename: FieldRename.snake)
class Certification {
  const Certification({
    required this.title,
    required this.issuer,
    required this.issueDate,
    this.credentialId = '',
    this.description = '',
    this.image = '',
    this.id,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);

  // id dibuat sama server, jadi gak ikut dikirim pas POST
  @JsonKey(includeToJson: false)
  final int? id;

  final String title;
  final String issuer;

  // format yyyy-mm-dd, sama kayak DateField di Django
  final String issueDate;

  // kalau di server null, diganti string kosong
  @JsonKey(defaultValue: '')
  final String credentialId;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String image;

  // 3 field di bawah dihitung server, jadi cuma dibaca dan gak dikirim balik
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  Map<String, dynamic> toJson() => _$CertificationToJson(this);
}
