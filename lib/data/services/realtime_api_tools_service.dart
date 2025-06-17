import 'package:flutter/material.dart';
import 'package:voice_interaction/config/realtime_api_tools.dart';
import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/domain/models/realtime_api_tool.dart';
import 'package:voice_interaction/domain/models/realtime_api_tool_param.dart';

class RealtimeApiToolsService {
  final PackageHandlerService _packageHandlerService;
  final DepartmentHandlerService _departmentHandlerService;
  final List<RealtimeApiTool> _tools = [];

  List<RealtimeApiTool> get tools => List.unmodifiable(_tools);

  RealtimeApiToolsService({
    required PackageHandlerService packageHandlerService,
    required DepartmentHandlerService departmentHandlerService,
  }) : _packageHandlerService = packageHandlerService,
       _departmentHandlerService = departmentHandlerService;

  RealtimeApiTool _loadPackageTool() {
    final packageNameParam = RealtimeApiToolParam(
      name: RealtimeApiTools.getHeathCarePackageToolParamName,
      description: RealtimeApiTools.getHeathCarePackageToolParamDescription,
      type: RealtimeApiToolParamType.string,
      required: true,
      enumValues: _packageHandlerService.packages.map((pkg) => pkg.package).toList(),
    );

    final getHealthCarePackageTool = RealtimeApiTool(
      name: RealtimeApiTools.getHealthCarePackageToolName,
      description: RealtimeApiTools.getHealthCarePackageToolDescription,
      parameters: List.filled(1, packageNameParam),
    );

    return getHealthCarePackageTool;
  }

  RealtimeApiTool _loadDepartmentDoctorsTool() {
    final departmentNameParam = RealtimeApiToolParam(
      name: RealtimeApiTools.getDepartmentDoctorsToolParamName,
      description: RealtimeApiTools.getDepartmentDoctorsToolParamDescription,
      type: RealtimeApiToolParamType.string,
      required: true,
      enumValues: _departmentHandlerService.departments.map((dept) => dept.department).toList(),
    );

    final getDepartmentDoctorsTool = RealtimeApiTool(
      name: RealtimeApiTools.getDepartmentDoctorsToolName,
      description: RealtimeApiTools.getDepartmentDoctorsToolDescription,
      parameters: List.filled(1, departmentNameParam),
    );

    return getDepartmentDoctorsTool;
  }

  RealtimeApiTool _loadDoctorsTool() {
    final getAllDoctorsTool = RealtimeApiTool(
      name: RealtimeApiTools.getAllDoctorsToolName,
      description: RealtimeApiTools.getAllDoctorsToolDescription,
    );

    return getAllDoctorsTool;
  }

  RealtimeApiTool _loadVolumeSetTool() {
    final volumeParam = RealtimeApiToolParam(
      name: RealtimeApiTools.changeVolumeToolParamName,
      description: RealtimeApiTools.changeVolumeToolParamDescription,
      type: RealtimeApiToolParamType.number,
      minimum: 0,
      maximum: 15,
      required: true,
    );

    final changeVolumeTool = RealtimeApiTool(
      name: RealtimeApiTools.changeVolumeToolName,
      description: RealtimeApiTools.changeVolumeToolDescription,
      parameters: List.filled(1, volumeParam),
    );

    return changeVolumeTool;
  }

  RealtimeApiTool _loadVolumeGetTool() {
    final getCurrentVolumeTool = RealtimeApiTool(
      name: RealtimeApiTools.getCurrentVolumeToolName,
      description: RealtimeApiTools.getCurrentVolumeToolDescription,
    );

    return getCurrentVolumeTool;
  }

  void loadTools() {
    final getHealthCarePackageTool = _loadPackageTool();
    final getDepartmentDoctorsTool = _loadDepartmentDoctorsTool();
    final getAllDoctorsTool = _loadDoctorsTool();
    final changeVolumeTool = _loadVolumeSetTool();
    final getCurrentVolumeTool = _loadVolumeGetTool();

    _tools.add(getHealthCarePackageTool);
    _tools.add(getDepartmentDoctorsTool);
    _tools.add(getAllDoctorsTool);
    _tools.add(changeVolumeTool);
    _tools.add(getCurrentVolumeTool);

    debugPrint(getHealthCarePackageTool.toJson().toString());
    debugPrint(getDepartmentDoctorsTool.toJson().toString());
    debugPrint(getAllDoctorsTool.toJson().toString());
    debugPrint(getCurrentVolumeTool.toJson().toString());
    debugPrint(changeVolumeTool.toJson().toString());
  }
}
