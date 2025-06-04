import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:voice_interaction/domain/models/health_package.dart';

class PackageHandlerService {
  static final List<HealthPackage> _packages = [];

  PackageHandlerService() {
    _loadPackages();
  }

  void _loadPackages() async {
    final packagesJson = await rootBundle.loadString('assets/packages.json');
    _packages.addAll((jsonDecode(packagesJson) as List)
      .map((e) => HealthPackage.fromJson(e))
      .toList());
  }

  static HealthPackage getPackage(String package) {
    return _packages.firstWhere((pkg) => pkg.package == package);
  }
}