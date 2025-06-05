import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/domain/models/realtime_connection_state.dart';
import 'package:voice_interaction/domain/models/realtime_speech_state.dart';
import 'package:voice_interaction/ui/core/models/display_details.dart';

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
            add(ConnectionStatusChanged(InteractionConnectionState.disconnected));
            break;
          case RealtimeConnectionState.connecting:
            add(ConnectionStatusChanged(InteractionConnectionState.connecting));
            break;
          case RealtimeConnectionState.connected:
            add(ConnectionStatusChanged(InteractionConnectionState.connected));
            break;
        }
      });
      _realtimeApiRepository.speechStateStream.listen((state) {
        switch (state) {
          case RealtimeSpeechState.idle:
            add(SpeechStateChanged(InteractionSpeechState.idle));
            break;
          case RealtimeSpeechState.listening:
            add(SpeechStateChanged(InteractionSpeechState.listening));
            break;
          case RealtimeSpeechState.speaking:
            add(SpeechStateChanged(InteractionSpeechState.speaking));
            break;
        }
      });

      on<StartSession>((event, emit) {
        _realtimeApiRepository.startSession(instruction: event.instruction);
        emit(InteractionConnecting());
      });

      on<ConnectionStatusChanged>((event, emit) {
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

      on<SpeechStateChanged>((event, emit) {
        if (state is InteractionConnected) {
          emit(InteractionConnected(speechState: _speechState, micMuted: _isMicMuted, details: null));
        }
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
