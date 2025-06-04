part of 'interaction_view_model.dart';

abstract class InteractionEvent {}

class StartSession extends InteractionEvent {
  final String instruction;

  StartSession({required this.instruction});
}

class ConnectionStatusChanged extends InteractionEvent {
  final ConnectionStatus status;

  ConnectionStatusChanged(this.status);
}

class SpeechStateChanged extends InteractionEvent {
  final SpeechState speechState;

  SpeechStateChanged(this.speechState);
}

class MuteMic extends InteractionEvent {}

class UnmuteMic extends InteractionEvent {}

class EndSession extends InteractionEvent {}