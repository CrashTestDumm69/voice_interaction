part of 'interaction_view_model.dart';

abstract class InteractionState {}

class InteractionInitial extends InteractionState {}

class InteractionConnecting extends InteractionState {}

class InteractionConnected extends InteractionState {
  final SpeechState speechState;
  final bool micMuted;

  InteractionConnected({required this.speechState, required this.micMuted});
}

class InteractionDisconnected extends InteractionState {}
