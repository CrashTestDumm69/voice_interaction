import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/config/realtime_api_data.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/ui/models/department_details.dart';
import 'package:voice_interaction/ui/models/display_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';
import 'package:voice_interaction/ui/models/package_detials.dart';
import 'package:voice_interaction/utils/injection_container.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

enum InteractionConnectionState {
  connected,
  connecting,
  disconnected
}

enum InteractionSpeechState {
  idle,
  speaking,
  listening
}

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final RealtimeApiRepository _realtimeApiRepository;

  InteractionSpeechState _speechState = InteractionSpeechState.idle;
  bool _isMicMuted = false;
  DisplayDetails? _details;

  InteractionViewModel({required RealtimeApiRepository repository})
    : _realtimeApiRepository = repository, super(InteractionInitial()) {
      on<StartSession>((event, emit) {
        emit(InteractionConnecting());
        
        onFunctionCall(functionName, arguments) {
          debugPrint("Function called: $functionName with arguments: $arguments");
          if (functionName == RealtimeApiData.getHealthcarPackageFunction) {
            final packageName = arguments['package_name'];
            final packageDetails = sl<PackageHandlerService>().getPackage(packageName);
            add(DetailsRequested(type: "package", request: arguments['package_name']));
            return {
              "success": true,
              "data": packageDetails.toJson()
            };
          } else if (functionName == RealtimeApiData.getDepartmentDoctorsFunction) {
            final departmentName = arguments['department_name'];
            final departmentDetails = sl<DepartmentHandlerService>().getDepartment(departmentName);
            add(DetailsRequested(type: "department", request: arguments['department_name']));
            return {
              "success": true,
              "data": departmentDetails.toJson()
            };
          } else {
            return {
              "success": false,
              "error": "Unknown function: $functionName"
            };
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
          add(ConnectionStatusChanged(status: InteractionConnectionState.connected));
        }

        onDisconnect() {
          debugPrint("Disconnected from interaction session");
          add(ConnectionStatusChanged(status: InteractionConnectionState.disconnected));
        }

        onMessage(dynamic message) {
          debugPrint("Message received in interaction session - $message");
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
          onFuntionCall: onFunctionCall
        );
      });

      on<ConnectionStatusChanged> ((event, emit) {
        if (event.status == InteractionConnectionState.connected) {
          _speechState = InteractionSpeechState.listening;
          _isMicMuted = false;
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
        } else if (event.status == InteractionConnectionState.connecting) {
          _speechState = InteractionSpeechState.idle;
          emit(InteractionConnecting());
        } else {
          _speechState = InteractionSpeechState.idle;
          emit(InteractionDisconnected());
        }
      });

      on<SpeechStateChanged> ((event, emit) {
        if (state is InteractionConnected) {
          _speechState = event.speechState;
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
        }
      });

      on<DetailsRequested>((event, emit) {
        if (event.type == "package") {
          final packageDetails = sl<PackageHandlerService>().getPackage(event.request);
          _details = PackageDetials(
            heading: packageDetails.package,
            description: packageDetails.description,
            price: packageDetails.price,
            tests: Grid(heading: "Tests", items: packageDetails.tests),
            consultations: Grid(heading: "Consultations", items: packageDetails.consultations)
          );

          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
        } else if (event.type == "department") {
          final departmentDetails = sl<DepartmentHandlerService>().getDepartment(event.request);
          _details = DepartmentDetails(
            heading: departmentDetails.department,
            description: departmentDetails.description,
            doctors: Grid(heading: "Doctors", items: departmentDetails.doctors),
          );

          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
        }
      });

      on<CloseDetails>((event, emit) {
        _details = null;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
      });

      on<MuteMic>((event, emit) {
        _realtimeApiRepository.muteMicrophone();
        _isMicMuted = true;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
      });

      on<UnmuteMic>((event, emit) {
        _realtimeApiRepository.unmuteMicrophone();
        _isMicMuted = false;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: _details));
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
