import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

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
      _realtimeApiRepository.connectionStatusStream.listen((state) => add(ConnectionStatusChanged(state)));
      _realtimeApiRepository.speechStateStream.listen((state) => add(SpeechStateChanged(state)));

      on<StartSession>((event, emit) {
        _realtimeApiRepository.startSession(instruction: event.instruction);
        emit(InteractionConnecting());
      });

      on<ConnectionStatusChanged>((event, emit) {
        if (event.status == ConnectionStatus.connected) {
          _speechState = InteractionSpeechState.listening;
          _isMicMuted = false;
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted));
        } else if (event.status == ConnectionStatus.connecting) {
          _speechState = InteractionSpeechState.idle;
          emit(InteractionConnecting());
        } else {
          _speechState = InteractionSpeechState.idle;
          emit(InteractionDisconnected());
        }
      });

      on<SpeechStateChanged>((event, emit) {
        if (state is InteractionConnected) {
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted));
        }
      });

      on<MuteMic>((event, emit) {
        _realtimeApiRepository.muteMicrophone();
        _isMicMuted = true;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted));
      });

      on<UnmuteMic>((event, emit) {
        _realtimeApiRepository.unmuteMicrophone();
        _isMicMuted = false;
        emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted));
      });

      on<EndSession>((event, emit) {
        _realtimeApiRepository.closeSession();
        _speechState = InteractionSpeechState.idle;
        _isMicMuted = false;
        emit(InteractionDisconnected());
      });
    }
}
