import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';
part 'department.g.dart';

@freezed
@JsonSerializable()
class Department with _$Department {
  @override
  String department;

  @override
  List<String> doctors;

  Department({
    required this.department,
    required this.doctors
  });

  factory Department.fromJson(Map<String, Object?> json) => _$DepartmentFromJson(json);

  Map<String, Object?> toJson() => _$DepartmentToJson(this);
}