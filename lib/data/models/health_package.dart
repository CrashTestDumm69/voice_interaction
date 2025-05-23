import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_package.freezed.dart';
part 'health_package.g.dart';

@freezed
@JsonSerializable()
class HealthPackage with _$HealthPackage{
  @override
  final String package;

  @override
  final int price;

  @override
  final List<String> tests;

  @override
  final List<String> consultations;

  @override
  final String description;

  HealthPackage({
    required this.package,
    required this.price,
    required this.tests,
    required this.consultations,
    required this.description
  });

  factory HealthPackage.fromJson(Map<String, Object?> json) => _$HealthPackageFromJson(json);

  Map<String, Object?> toJson() => _$HealthPackageToJson(this);
}