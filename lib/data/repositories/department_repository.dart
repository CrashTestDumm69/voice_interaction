import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/domain/models/department.dart';

class DepartmentRepository {
  final DepartmentHandlerService _departmentHandlerService;

  DepartmentRepository({required DepartmentHandlerService departmentHandlerService})
      : _departmentHandlerService = departmentHandlerService;

  List<Department> get departments => _departmentHandlerService.departments;

  Department? getDepartment(String department) {
    return _departmentHandlerService.getDepartment(department);
  }
}