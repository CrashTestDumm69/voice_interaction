import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:voice_interaction/data/models/doctor.dart';

class DoctorHandlerService {
  final List<Doctor> _doctors = [];
  final List<String> _doctorNames = [];

  List<Doctor> get doctors => _doctors;
  List<String> get doctorNames => _doctorNames;

  Future<void> loaddoctors() async {
    final doctorsJson = await rootBundle.loadString('assets/doctors.json');
    _doctors.addAll((jsonDecode(doctorsJson) as List)
      .map((e) => Doctor.fromJson(e))
      .toList());
    _doctorNames.addAll(_doctors.map((doc) => doc.doctor).toList());
  }
}