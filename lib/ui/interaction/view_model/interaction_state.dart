import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:voice_interaction/data/models/health_package.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

part 'interaction_state.freezed.dart';

@freezed
class InteractionState with _$InteractionState{
  @override
  final RealtimeConnectionState connectionState;

  @override
  final SpeechState speechState;

  @override
  final HealthPackage? packageDetails;

  @override
  final bool isMicMuted;

  InteractionState({
    required this.connectionState,
    required this.speechState,
    required this.packageDetails,
    required this.isMicMuted
  });

  factory InteractionState.initial() => InteractionState(
    connectionState: RealtimeConnectionState.disconnected,
    speechState: SpeechState.idle,
    packageDetails: null,
    isMicMuted: false,
  );
}