import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

class RealtimeApiRepository {
  final RealtimeApiService _realtimeApiService;

  RealtimeApiRepository({required RealtimeApiService service})
    : _realtimeApiService = service;

  Future<void> startSession({required String instruction}) async {
    final apiKey = DotenvService.getApiKey();
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