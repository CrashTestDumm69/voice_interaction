import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';

class RealtimeApiRepository {
  final RealtimeApiService _realtimeApiService;
  final DotenvService _dotenvService;

  RealtimeApiRepository({required RealtimeApiService realtimeApiService, required DotenvService dotenvService})
      : _realtimeApiService = realtimeApiService,
        _dotenvService = dotenvService;

  Future<void> startSession({
    required void Function() onSpeak,
    required void Function() onListen,
    required void Function() onConnect,
    required void Function() onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    required Future<Map<String, dynamic>> Function(String functionName, Map<String, dynamic> arguments) onFunctionCall
  }) async {
    final apiKey = _dotenvService.getApiKey();
    await _realtimeApiService.initConnection(
      apiKey,
      onConnect: onConnect,
      onDisconnect: onDisconnect,
      onSpeak: onSpeak,
      onListen: onListen,
      onMessage: onMessage,
      onError: onError,
      onFunctionCall: onFunctionCall
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