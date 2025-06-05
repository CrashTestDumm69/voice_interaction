part of 'interaction_view_model.dart';

abstract class InteractionState {}

class InteractionInitial extends InteractionState {}

class InteractionConnecting extends InteractionState {}

class InteractionConnected extends InteractionState {
  final InteractionSpeechState speechState;
  final bool micMuted;
  final DisplayDetails? details;

  InteractionConnected({required this.speechState, required this.micMuted, required this.details});
}

class InteractionDisconnected extends InteractionState {}
