import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

class RealtimeApiRepository {
  final RealtimeApiService _realtimeApiService;

  RealtimeApiRepository({required RealtimeApiService service})
    : _realtimeApiService = service;

  Future<void> startSession({
    required String instruction,
    required void Function() onSpeak,
    required void Function() onListen,
    required void Function() onConnect,
    required void Function() onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    required Map<String, dynamic> Function(String functionName, Map<String, dynamic> arguments) onFuntionCall
  }) async {
    final apiKey = DotenvService.getApiKey();
    await _realtimeApiService.initConnection(
      apiKey, instruction,
      onConnect: onConnect,
      onDisconnect: onDisconnect,
      onSpeak: onSpeak,
      onListen: onListen,
      onMessage: onMessage,
      onError: onError,
      onFuntionCall: onFuntionCall
    );
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