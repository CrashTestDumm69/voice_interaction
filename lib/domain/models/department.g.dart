// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
  department: json['department'] as String,
  description: json['description'] as String,
  doctors: (json['doctors'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'department': instance.department,
      'description': instance.description,
      'doctors': instance.doctors,
    };
