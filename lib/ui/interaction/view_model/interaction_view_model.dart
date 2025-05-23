import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/config/realtime_api_data.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_event.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_state.dart';

class InteractionViewModel extends Bloc<InteractionEvent, InteractionState> {
  final RealtimeApiService service = RealtimeApiService();
  StreamSubscription? _connectionState; 
  StreamSubscription? _speechState;

  InteractionViewModel() : super(InteractionState.initial()) {
    on<InitializeEvent>((event, emit) {
      _connectionState = service.connectionState.listen((connectionState) => emit(state.copyWith(connectionState: connectionState)));
      _speechState = service.speechState.listen((speechState) => emit(state.copyWith(speechState: speechState)));
    });
    
    on<StartApiConnectionEvent>((event, emit) async {
      await _initService(event.language == "English" ? RealtimeApiData.englishInstructions : RealtimeApiData.tamilInstructions);
    });

    on<EndApiSessionEvent>((event, emit) {
      _stopService();
    });
  }

  Future<void> _initService(String instruction) async {
    await service.initConnection(instruction);
  }

  void _stopService() {
    service.dispose();
  }

  void unmuteMic() {
    service.unmuteMic();
  }

  void dispose() {
    _connectionState?.cancel();
    _speechState?.cancel();
    service.dispose();
  }
}
