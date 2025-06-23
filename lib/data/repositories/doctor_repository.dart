import 'package:voice_interaction/data/services/doctor_handler_service.dart';
import 'package:voice_interaction/domain/models/doctor.dart';

class DoctorRepository {
  final DoctorHandlerService _doctorHandlerService;
  
  DoctorRepository({required DoctorHandlerService doctorHandlerService})
      : _doctorHandlerService = doctorHandlerService;
  
  List<Doctor> get doctors => _doctorHandlerService.doctors;
  
  Doctor? getDoctor(String doctorName) {
    return _doctorHandlerService.getDoctor(doctorName);
  }
}