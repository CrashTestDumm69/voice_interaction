part of 'interaction_view_model.dart';

class InteractionState {
  final RealtimeConnectionState connectionState;
  final SpeechState speechState;
  final HealthPackage? packageDetails;
  final bool isMicMuted;

  InteractionState({
    required this.connectionState,
    required this.speechState,
    required this.packageDetails,
    required this.isMicMuted,
  });

  factory InteractionState.initial() => InteractionState(
        connectionState: RealtimeConnectionState.disconnected,
        speechState: SpeechState.idle,
        packageDetails: null,
        isMicMuted: false,
      );

  InteractionState copyWith({
    RealtimeConnectionState? connectionState,
    SpeechState? speechState,
    HealthPackage? packageDetails,
    bool? isMicMuted,
  }) {
    return InteractionState(
      connectionState: connectionState ?? this.connectionState,
      speechState: speechState ?? this.speechState,
      packageDetails: packageDetails ?? this.packageDetails,
      isMicMuted: isMicMuted ?? this.isMicMuted,
    );
  }
}
