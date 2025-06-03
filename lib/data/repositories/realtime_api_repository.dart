import 'package:voice_interaction/data/services/realtime_api_service.dart';

class RealtimeApiRepository {
  final RealtimeApiService _realtimeApiService;

  RealtimeApiRepository({RealtimeApiService service})
      : _realtimeApiService = service;

  Future<void> startSession({
    required String apiKey,
    required String instruction,
  }) async {
    await _realtimeApiService.initConnection(apiKey, instruction);
  }

  void muteMicrophone() {
    _realtimeApiService.muteMic();
  }

  void unmuteMicrophone() {
    _realtimeApiService.unmuteMic();
  }

  void closeSession() {
    _realtimeApiService.close();
  }

  void dispose() {
    _realtimeApiService.dispose();
  }
}
