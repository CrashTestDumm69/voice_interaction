import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/config/live_api_tools.dart';

import 'package:voice_interaction/data/repositories/live_api_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

enum InteractionConnectionState { connected, connecting, disconnected }

enum InteractionSpeechState { idle, speaking, listening }

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final LiveApiRepository _liveApiRepository;
  final VolumeRepositroy _volumeRepository;

  InteractionSpeechState _speechState = InteractionSpeechState.idle;
  bool _isMicMuted = false;

  InteractionViewModel({
    required LiveApiRepository liveApiRepository,
    required VolumeRepositroy volumeRepository,
  }) : _liveApiRepository = liveApiRepository,
       _volumeRepository = volumeRepository,
       super(InteractionInitial()) {
    on<StartSession>((event, emit) {
      emit(InteractionConnecting());

      onFunctionCall(functionName, arguments) async {
        debugPrint("Function called: $functionName with arguments: $arguments");
        if (functionName == LiveApiTools.changeVolumeToolName) {
          final volume = arguments['volume'] as int;
          volume.clamp(0, 15);
          await _volumeRepository.setVolume(volume);
          return {"success": true, "data": "Volume set to $volume"};
        } else if (functionName == LiveApiTools.getCurrentVolumeToolName) {
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

      // _liveApiRepository.startSession(
      //   onSpeak: onSpeak,
      //   onConnect: onConnect,
      //   onDisconnect: onDisconnect,
      //   onListen: onListen,
      //   onMessage: onMessage,
      //   onError: onError,
      //   onFunctionCall: onFunctionCall,
      // );
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
      _liveApiRepository.muteMicrophone();
      _isMicMuted = true;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
        ),
      );
    });

    on<UnmuteMic>((event, emit) {
      _liveApiRepository.unmuteMicrophone();
      _isMicMuted = false;
      emit(
        InteractionConnected(
          speechState: _speechState,
          micMuted: _isMicMuted,
        ),
      );
    });

    on<EndSession>((event, emit) {
      _liveApiRepository.closeSession();
      _speechState = InteractionSpeechState.idle;
      _isMicMuted = false;
      emit(InteractionDisconnected());
    });
  }
}
