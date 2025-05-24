abstract class InteractionEvent {}

class InitializeEvent extends InteractionEvent {}

class StartApiConnectionEvent extends InteractionEvent {
  final String language;

  StartApiConnectionEvent({required this.language});
}

class EndApiSessionEvent extends InteractionEvent {}

class ClosePackageDetailsEvent extends InteractionEvent {}

class ToggleMicrophoneEvent extends InteractionEvent {}