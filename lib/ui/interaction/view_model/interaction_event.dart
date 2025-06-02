part of 'interaction_view_model.dart';

abstract class InteractionEvent {}

class InitializeEvent extends InteractionEvent {}

class StartApiConnectionEvent extends InteractionEvent {
  final String language;

  StartApiConnectionEvent({required this.language});
}

class EndApiSessionEvent extends InteractionEvent {}

class ClosePackageDetailsEvent extends InteractionEvent {}

class ToggleMicrophoneEvent extends InteractionEvent {}

class InteractionStateChanged extends InteractionEvent {
  final InteractionState interactionState;

  InteractionStateChanged({required this.interactionState});
}