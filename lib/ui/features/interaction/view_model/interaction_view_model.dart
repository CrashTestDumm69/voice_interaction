import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/config/realtime_api_tools.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

enum InteractionConnectionState { connected, connecting, disconnected }

enum InteractionSpeechState { idle, speaking, listening }

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final RealtimeApiRepository _realtimeApiRepository;
  final VolumeRepositroy _volumeRepository;

  InteractionSpeechState _speechState = InteractionSpeechState.idle;
  bool _isMicMuted = false;

  InteractionViewModel({
    required RealtimeApiRepository realtimeApiRepository,
    required VolumeRepositroy volumeRepository,
  }) : _realtimeApiRepository = realtimeApiRepository,
       _volumeRepository = volumeRepository,
       super(InteractionInitial()) {
    on<StartSession>((event, emit) {
      emit(InteractionConnecting());

      onFunctionCall(functionName, arguments) async {
        debugPrint("Function called: $functionName with arguments: $arguments");
        if (functionName == RealtimeApiTools.changeVolumeToolName) {
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
          ),
        );
      }
    });

    on<VolumeChangePressed>((event, emit) async {
      final currentVolume = await _volumeRepository.getVolume();
      await _volumeRepository.setVolume(currentVolume);
    });

    on<MuteMic>((event, emit) {
      _realtimeApiRepository.muteMicrophone();
      _isMicMuted = true;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
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
        ),
      );
    });

    on<EndSession>((event, emit) {
      _realtimeApiRepository.closeSession();
      _speechState = InteractionSpeechState.idle;
      _isMicMuted = false;
      emit(InteractionDisconnected());
    });
  }
}
