import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:voice_interaction/domain/models/doctor.dart';

class DoctorHandlerService {
  final List<Doctor> _doctors = [];

  List<Doctor> get doctors => List.unmodifiable(_doctors);

  Future<void> loadDoctors() async {
    final doctorsJson = await rootBundle.loadString('assets/doctors.json');
    _doctors.addAll((jsonDecode(doctorsJson) as List)
      .map((e) => Doctor.fromJson(e))
      .toList());
  }

  Doctor? getDoctor(String doctorName) {
    return _doctors.firstWhereOrNull((doc) => doc.doctor == doctorName);
  }
}