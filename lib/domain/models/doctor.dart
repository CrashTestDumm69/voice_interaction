import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
@JsonSerializable()
class Doctor with _$Doctor {
  @override
  String doctor;

  @override
  String department;

  Doctor({
    required this.doctor,
    required this.department
  });

  factory Doctor.fromJson(Map<String, Object?> json) => _$DoctorFromJson(json);

  Map<String, Object?> toJson() => _$DoctorToJson(this);
}