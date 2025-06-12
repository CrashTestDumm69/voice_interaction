import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:voice_interaction/domain/models/department.dart';

class DepartmentHandlerService {
  final List<Department> _departments = [];

  List<Department> get departments => _departments;

  Future<void> loadDepartments() async {
    final departmentsJson = await rootBundle.loadString('assets/departments.json');
    _departments.addAll((jsonDecode(departmentsJson) as List)
      .map((e) => Department.fromJson(e))
      .toList());
  }

  Department? getDepartment(String department) {
    return _departments.firstWhereOrNull((dept) => dept.department == department);
  }
}