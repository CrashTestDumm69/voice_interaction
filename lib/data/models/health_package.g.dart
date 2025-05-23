// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthPackage _$HealthPackageFromJson(Map<String, dynamic> json) =>
    HealthPackage(
      package: json['package'] as String,
      price: (json['price'] as num).toInt(),
      tests: (json['tests'] as List<dynamic>).map((e) => e as String).toList(),
      consultations:
          (json['consultations'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$HealthPackageToJson(HealthPackage instance) =>
    <String, dynamic>{
      'package': instance.package,
      'price': instance.price,
      'tests': instance.tests,
      'consultations': instance.consultations,
      'description': instance.description,
    };
