import 'package:freezed_annotation/freezed_annotation.dart';

part 'blob.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Blob {
  String mimeType;
  String data;

  Blob({
    required this.mimeType,
    required this.data,
  });

  factory Blob.fromJson(Map<String, dynamic> json) => _$BlobFromJson(json);
  Map<String, dynamic> toJson() => _$BlobToJson(this);
}