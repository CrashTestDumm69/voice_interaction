import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/config/realtime_api_data.dart';
import 'package:voice_interaction/data/models/health_package.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

part 'interaction_event.dart';
part 'interaction_state.dart';

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final RealtimeApiService service = RealtimeApiService();
  StreamSubscription? _connectionState; 
  StreamSubscription? _speechState;
  StreamSubscription? _packageDetails;

  InteractionViewModel() : super(InteractionState.initial()) {
    on<InteractionStateChanged>((event, emit) => emit(event.interactionState));

    on<InitializeEvent>((event, emit) {
      _connectionState = service.connectionState.listen((connectionState) => add(InteractionStateChanged(interactionState: state.copyWith(connectionState: connectionState))));
      _speechState = service.speechState.listen((speechState) => add(InteractionStateChanged(interactionState: state.copyWith(speechState: speechState))));
      _packageDetails = service.packageDetails.listen((package) => add(InteractionStateChanged(interactionState: state.copyWith(packageDetails: package))));
    });
    
    on<StartApiConnectionEvent>((event, emit) {
      service.initConnection(event.language == "English" ? RealtimeApiData.englishInstructions : RealtimeApiData.tamilInstructions);
    });

    on<EndApiSessionEvent>((event, emit) {
      service.dispose();
      emit(InteractionState.initial());
    });

    on<ToggleMicrophoneEvent>((event, emit) {
      if(service.isMicMuted) {
        service.unmuteMic();
        emit(state.copyWith(isMicMuted: false));
      } else {
        service.muteMic();
        emit(state.copyWith(isMicMuted: true));
      }
    });

    on<ClosePackageDetailsEvent>((event, emit) {
      service.clearPackage();
    });
  }

  void dispose() {
    _connectionState?.cancel();
    _speechState?.cancel();
    _packageDetails?.cancel();
    service.dispose();
  }
}
