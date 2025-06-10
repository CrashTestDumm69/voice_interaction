import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/domain/models/realtime_connection_state.dart';
import 'package:voice_interaction/domain/models/realtime_speech_state.dart';
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

  InteractionViewModel({required RealtimeApiRepository repository})
    : _realtimeApiRepository = repository, super(InteractionInitial()) {
      _realtimeApiRepository.connectionStateStream.listen((state) {
        switch (state) {
          case RealtimeConnectionState.disconnected:
            add(ConnectionStatusChanged(status: InteractionConnectionState.disconnected));
            break;
          case RealtimeConnectionState.connecting:
            add(ConnectionStatusChanged(status: InteractionConnectionState.connecting));
            break;
          case RealtimeConnectionState.connected:
            add(ConnectionStatusChanged(status: InteractionConnectionState.connected));
            break;
        }
      });
      _realtimeApiRepository.speechStateStream.listen((state) {
        switch (state) {
          case RealtimeSpeechState.idle:
            add(SpeechStateChanged(speechState: InteractionSpeechState.idle));
            break;
          case RealtimeSpeechState.listening:
            add(SpeechStateChanged(speechState: InteractionSpeechState.listening));
            break;
          case RealtimeSpeechState.speaking:
            add(SpeechStateChanged(speechState: InteractionSpeechState.speaking));
            break;
        }
      });

      on<StartSession>((event, emit) {
        _realtimeApiRepository.startSession(instruction: event.instruction);
        emit(InteractionConnecting());
      });

      on<ConnectionStatusChanged> ((event, emit) {
        if (event.status == InteractionConnectionState.connected) {
          _speechState = InteractionSpeechState.listening;
          _isMicMuted = false;
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
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
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
        }
      });

      on<DetailsRequested>((event, emit) {
        if (event.type == "package") {
          final packageDetails = sl<PackageHandlerService>().getPackage(event.request);
          final details = PackageDetials(
            heading: packageDetails.package,
            description: packageDetails.description,
            price: packageDetails.price,
            tests: Grid(heading: "Tests", items: packageDetails.tests),
            consultations: Grid(heading: "Consultations", items: packageDetails.consultations)
          );

          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: details));
        } else if (event.type == "department") {
          final departmentDetails = sl<DepartmentHandlerService>().getDepartment(event.request);
          final details = DepartmentDetails(
            heading: departmentDetails.department,
            description: departmentDetails.description,
            doctors: Grid(heading: "Doctors", items: departmentDetails.doctors),
          );

          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: details));
        }
      });

      on<CloseDetails>((event, emit) {
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
      });

      on<MuteMic>((event, emit) {
        _realtimeApiRepository.muteMicrophone();
        _isMicMuted = true;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
      });

      on<UnmuteMic>((event, emit) {
        _realtimeApiRepository.unmuteMicrophone();
        _isMicMuted = false;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
      });

      on<EndSession>((event, emit) {
        _realtimeApiRepository.closeSession();
        _speechState = InteractionSpeechState.idle;
        _isMicMuted = false;
        emit(InteractionDisconnected());
      });
    }
}
