import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/live_api_service.dart';

class LiveApiRepository {
  final LiveApiService _liveApiService;
  final DotenvService _dotenvService;

  LiveApiRepository({required LiveApiService liveApiService, required DotenvService dotenvService})
      : _liveApiService = liveApiService,
        _dotenvService = dotenvService;

  Future<void> startSession({
    void Function()? onSpeak,
    void Function()? onListen,
    void Function()? onConnect,
    void Function()? onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    Future<Map<String, dynamic>> Function(String functionName, Map<String, dynamic> arguments)? onFunctionCall
  }) async {
    final apiKey = _dotenvService.getApiKey();
    await _liveApiService.initConnection(apiKey);
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