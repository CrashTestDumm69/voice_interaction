import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:voice_interaction/data/models/department.dart';

class DepartmentHandlerService {
  final List<Department> _departments = [];
  final List<String> _departmentNames = [];

  List<Department> get departments => _departments;
  List<String> get departmentNames => _departmentNames;

  Future<void> loaddepartments() async {
    final departmentsJson = await rootBundle.loadString('assets/departments.json');
    _departments.addAll((jsonDecode(departmentsJson) as List)
      .map((e) => Department.fromJson(e))
      .toList());
    _departmentNames.addAll(_departments.map((dept) => dept.department).toList());
  }
}