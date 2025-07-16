// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blob.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blob _$BlobFromJson(Map<String, dynamic> json) =>
    Blob(mimeType: json['mimeType'] as String, data: json['data'] as String);

Map<String, dynamic> _$BlobToJson(Blob instance) => <String, dynamic>{
  'mimeType': instance.mimeType,
  'data': instance.data,
};
