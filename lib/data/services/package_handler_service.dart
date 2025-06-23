import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:voice_interaction/domain/models/health_package.dart';

class PackageHandlerService {
  final List<HealthPackage> _packages = [];

  List<HealthPackage> get packages => List.unmodifiable(_packages);

  Future<void> loadPackages() async {
    final packagesJson = await rootBundle.loadString('assets/packages.json');
    _packages.addAll((jsonDecode(packagesJson) as List)
      .map((e) => HealthPackage.fromJson(e))
      .toList());
  }

  HealthPackage? getPackage(String package) {
    return _packages.firstWhereOrNull((pkg) => pkg.package == package);
  }
}