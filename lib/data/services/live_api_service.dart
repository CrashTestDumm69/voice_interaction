import 'package:dio/dio.dart';

import 'package:voice_interaction/data/services/live_api_tools_service.dart';

class LiveApiService {
  final Dio _dio;
  final LiveApiToolsService _liveApiToolsService;

  LiveApiService({required LiveApiToolsService liveApiToolsService, required Dio dio})
      : _liveApiToolsService = liveApiToolsService,
        _dio = dio;

  Future<void> initConnection(
    String apiKey, {
    required void Function()? onSpeak,
    required void Function()? onListen,
    required void Function()? onConnect,
    required void Function()? onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    Future<Map<String, dynamic>> Function(
      String functionName,
      Map<String, dynamic> args,
    )?
    onFunctionCall,
  }) async {}

  void returnFunctionCall(Map<String, dynamic> msg) async {}

  void muteMic() {}

  void unmuteMic() {}

  void close() {}
}
