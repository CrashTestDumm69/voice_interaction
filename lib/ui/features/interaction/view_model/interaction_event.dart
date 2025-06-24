part of 'interaction_view_model.dart';

abstract class InteractionEvent {}

class StartSession extends InteractionEvent {}

class ConnectionStatusChanged extends InteractionEvent {
  final InteractionConnectionState status;

  ConnectionStatusChanged({required this.status});
}

class SpeechStateChanged extends InteractionEvent {
  final InteractionSpeechState speechState;

  SpeechStateChanged({required this.speechState});
}

class DetailsRequested extends InteractionEvent {
  final String request;
  final String type;

  DetailsRequested({required this.request, required this.type});
}

class CloseDetails extends InteractionEvent {}

class VolumeChangePressed extends InteractionEvent {}

class MuteMic extends InteractionEvent {}

class UnmuteMic extends InteractionEvent {}

class EndSession extends InteractionEvent {}