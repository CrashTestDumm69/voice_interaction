import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/domain/models/health_package.dart';

class PackageRepository {
  final PackageHandlerService _packageHandlerService;
  
  PackageRepository({required PackageHandlerService packageHandlerService})
      : _packageHandlerService = packageHandlerService;
  
  List<HealthPackage> get packages => _packageHandlerService.packages;
  
  HealthPackage? getPackage(String package) {
    return _packageHandlerService.getPackage(package);
  }
}