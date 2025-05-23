import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:voice_interaction/data/models/health_package.dart';

class PackageHandlerService {
  final List<HealthPackage> _packages = [];
  final List<String> _packageNames = [];

  List<HealthPackage> get packages => _packages;
  List<String> get packageNames => _packageNames;

  Future<void> loadPackages() async {
    final packagesJson = await rootBundle.loadString('assets/packages.json');
    _packages.addAll((jsonDecode(packagesJson) as List)
      .map((e) => HealthPackage.fromJson(e))
      .toList());
    _packageNames.addAll(_packages.map((pkg) => pkg.package).toList());
  }
}