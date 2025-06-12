class RealtimeApiTools {
  static const String getHealthCarePackageToolName = 'get_healthcare_package';
  static const String getHealthCarePackageToolDescription = 'Retrieve details of a health check-up package. Tell the user to wait a moment while you fetch the details. If the result is a success, tell the user that the details are on the screen.';
  static const String getHeathCarePackageToolParamName = 'package_name';
  static const String getHeathCarePackageToolParamDescription = 'Exact name of the health package';
  
  static const String getDepartmentDoctorsToolName = 'get_department_doctors';
  static const String getDepartmentDoctorsToolDescription = 'Retrieve the list of doctors in a specific department. Tell the user to wait a moment while you fetch the details. If the result is a success, tell the user that the details are on the screen.';
  static const String getDepartmentDoctorsToolParamName = 'department_name';
  static const String getDepartmentDoctorsToolParamDescription = 'Exact name of the department';

  static const String getAllDoctorsToolName = 'get_all_doctors';
  static const String getAllDoctorsToolDescription = 'Retrieve the list of all doctors. Tell the user to wait a moment while you fetch the details. If the result is a success, tell the user that the details are on the screen.';
}
