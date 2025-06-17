import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/config/realtime_api_tools.dart';
import 'package:voice_interaction/data/repositories/department_repository.dart';
import 'package:voice_interaction/data/repositories/doctor_repository.dart';
import 'package:voice_interaction/data/repositories/package_repository.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';
import 'package:voice_interaction/ui/models/department_details.dart';
import 'package:voice_interaction/ui/models/display_details.dart';
import 'package:voice_interaction/ui/models/doctors_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';
import 'package:voice_interaction/ui/models/package_detials.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

enum InteractionConnectionState { connected, connecting, disconnected }

enum InteractionSpeechState { idle, speaking, listening }

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final RealtimeApiRepository _realtimeApiRepository;
  final PackageRepository _packageRepository;
  final DepartmentRepository _departmentRepository;
  final DoctorRepository _doctorRepository;
  final VolumeRepositroy _volumeRepository;

  InteractionSpeechState _speechState = InteractionSpeechState.idle;
  bool _isMicMuted = false;
  DisplayDetails? _details;

  InteractionViewModel({
    required RealtimeApiRepository realtimeApiRepository,
    required PackageRepository packageRepository,
    required DepartmentRepository departmentRepository,
    required DoctorRepository doctorRepository,
    required VolumeRepositroy volumeRepository,
  }) : _realtimeApiRepository = realtimeApiRepository,
       _packageRepository = packageRepository,
       _departmentRepository = departmentRepository,
       _doctorRepository = doctorRepository,
       _volumeRepository = volumeRepository,
       super(InteractionInitial()) {
    on<StartSession>((event, emit) {
      emit(InteractionConnecting());

      onFunctionCall(functionName, arguments) async {
        debugPrint("Function called: $functionName with arguments: $arguments");
        if (functionName == RealtimeApiTools.getHealthCarePackageToolName) {
          final packageName = arguments['package_name'];
          final packageDetails = _packageRepository.getPackage(packageName);
          if (packageDetails == null) {
            return {
              "success": false,
              "error": "Package not found: $packageName",
            };
          }
          add(
            DetailsRequested(
              type: "package",
              request: arguments['package_name'],
            ),
          );
          return {"success": true, "data": packageDetails.toJson()};
        } else if (functionName == RealtimeApiTools.getDepartmentDoctorsToolName) {
          final departmentName = arguments['department_name'];
          final departmentDetails = _departmentRepository.getDepartment(departmentName);
          if (departmentDetails == null) {
            return {
              "success": false,
              "error": "Department not found: $departmentName",
            };
          }
          add(
            DetailsRequested(
              type: "department",
              request: arguments['department_name'],
            ),
          );
          return {"success": true, "data": departmentDetails.toJson()};
        } else if (functionName == RealtimeApiTools.getAllDoctorsToolName) {
          final doctors = _doctorRepository.doctors;
          if (doctors.isEmpty) {
            return {"success": false, "error": "No doctors found"};
          }
          add(
            DetailsRequested(
              type: "doctors",
              request: "",
            )
          );
          return {"success": true, "data": "Doctors are on the screen"};
        } else if (functionName == RealtimeApiTools.changeVolumeToolName) {
          final volume = arguments['volume'] as int;
          volume.clamp(0, 15);
          await _volumeRepository.setVolume(volume);
          return {"success": true, "data": "Volume set to $volume"};
        } else if (functionName == RealtimeApiTools.getCurrentVolumeToolName) {
          final currentVolume = await _volumeRepository.getVolume();
          return {"success": true, "data": currentVolume};
        } else {
          return {"success": false, "error": "Unknown function: $functionName"};
        }
      }

      onSpeak() {
        debugPrint("Robot speaking");
        add(SpeechStateChanged(speechState: InteractionSpeechState.speaking));
      }

      onListen() {
        debugPrint("Robot listening");
        add(SpeechStateChanged(speechState: InteractionSpeechState.listening));
      }

      onConnect() {
        debugPrint("Connected to interaction session");
        add(
          ConnectionStatusChanged(status: InteractionConnectionState.connected),
        );
      }

      onDisconnect() {
        debugPrint("Disconnected from interaction session");
        add(
          ConnectionStatusChanged(
            status: InteractionConnectionState.disconnected,
          ),
        );
      }

      onMessage(dynamic message) {
        // debugPrint("Message received in interaction session - $message");
      }

      onError(dynamic error) {
        debugPrint("Error in interaction: $error");
      }

      _realtimeApiRepository.startSession(
        instruction: event.instruction,
        onSpeak: onSpeak,
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        onListen: onListen,
        onMessage: onMessage,
        onError: onError,
        onFunctionCall: onFunctionCall,
      );
    });

    on<ConnectionStatusChanged>((event, emit) {
      if (event.status == InteractionConnectionState.connected) {
        _speechState = InteractionSpeechState.listening;
        _isMicMuted = false;
        emit(
          InteractionConnected(
            speechState: _speechState,
            micMuted: _isMicMuted,
            details: _details,
          ),
        );
      } else if (event.status == InteractionConnectionState.connecting) {
        _speechState = InteractionSpeechState.idle;
        emit(InteractionConnecting());
      } else {
        _speechState = InteractionSpeechState.idle;
        emit(InteractionDisconnected());
      }
    });

    on<SpeechStateChanged>((event, emit) {
      if (state is InteractionConnected) {
        _speechState = event.speechState;
        emit(
          InteractionConnected(
            speechState: _speechState,
            micMuted: _isMicMuted,
            details: _details,
          ),
        );
      }
    });

    on<VolumeChangePressed>((event, emit) async {
      final currentVolume = await _volumeRepository.getVolume();
      await _volumeRepository.setVolume(currentVolume);
    });

    on<DetailsRequested>((event, emit) {
      if (event.type == "package") {
        final packageDetails = _packageRepository.getPackage(event.request);
        if (packageDetails == null) {
          return;
        }
        _details = PackageDetials(
          heading: packageDetails.package,
          description: packageDetails.description,
          price: packageDetails.price,
          tests: Grid(heading: "Tests", items: packageDetails.tests),
          consultations: Grid(
            heading: "Consultations",
            items: packageDetails.consultations,
          ),
        );

        emit(
          InteractionConnected(
            speechState: _speechState,
            micMuted: _isMicMuted,
            details: _details,
          ),
        );
      } else if (event.type == "department") {
        final departmentDetails = _departmentRepository.getDepartment(
          event.request,
        );
        if (departmentDetails == null) {
          return;
        }
        _details = DepartmentDetails(
          heading: departmentDetails.department,
          description: departmentDetails.description,
          doctors: Grid(heading: "Doctors", items: departmentDetails.doctors),
        );

        emit(
          InteractionConnected(
            speechState: _speechState,
            micMuted: _isMicMuted,
            details: _details,
          ),
        );
      } else if (event.type == "doctors") {
        final doctors = _doctorRepository.doctors;
        _details = DoctorsDetails(
          heading: "Doctors",
          items: Grid(
            heading: "List of all doctors",
            items: doctors.map((doctor) => "${doctor.doctor}: ${doctor.department}").toList(),
          ),
        );

        emit(
          InteractionConnected(
            speechState: _speechState,
            micMuted: _isMicMuted,
            details: _details,
          ),
        );
      }
    });

    on<CloseDetails>((event, emit) {
      _details = null;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
          details: _details,
        ),
      );
    });

    on<MuteMic>((event, emit) {
      _realtimeApiRepository.muteMicrophone();
      _isMicMuted = true;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
          details: _details,
        ),
      );
    });

    on<UnmuteMic>((event, emit) {
      _realtimeApiRepository.unmuteMicrophone();
      _isMicMuted = false;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
          details: _details,
        ),
      );
    });

    on<EndSession>((event, emit) {
      _realtimeApiRepository.closeSession();
      _speechState = InteractionSpeechState.idle;
      _isMicMuted = false;
      _details = null;
      emit(InteractionDisconnected());
    });
  }
}
