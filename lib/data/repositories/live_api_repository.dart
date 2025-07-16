import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/live_api_service.dart';

class LiveApiRepository {
  final LiveApiService _liveApiService;
  final DotenvService _dotenvService;

  LiveApiRepository({required LiveApiService liveApiService, required DotenvService dotenvService})
      : _liveApiService = liveApiService,
        _dotenvService = dotenvService;

  Future<void> startSession({
    required void Function()? onSpeak,
    required void Function()? onListen,
    required void Function()? onConnect,
    required void Function()? onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    required Future<Map<String, dynamic>> Function(String functionName, Map<String, dynamic> arguments)? onFunctionCall
  }) async {
    final apiKey = _dotenvService.getApiKey();
    await _liveApiService.initConnection(
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
    _liveApiService.muteMic();
  }

  void unmuteMicrophone() {
    _liveApiService.unmuteMic();
  }

  void closeSession() {
    _liveApiService.close();
  }

  void dispose() {
    closeSession();
  }
}