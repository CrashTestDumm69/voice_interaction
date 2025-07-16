import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:voice_interaction/config/live_api_config.dart';
import 'package:voice_interaction/domain/models/live_api/live_api_message/live_api_message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveApiService {
  final Dio _dio;

  LiveApiService({required Dio dio})
      : _dio = dio;

  Future<void> initConnection(
    String apiKey, {
    void Function()? onSpeak,
    void Function()? onListen,
    void Function()? onConnect,
    void Function()? onDisconnect,
    void Function(dynamic message)? onMessage,
    void Function(dynamic error)? onError,
    Future<Map<String, dynamic>> Function(
      String functionName,
      Map<String, dynamic> args,
    )?
    onFunctionCall,
  }) async {
    final IOWebSocketChannel channel = IOWebSocketChannel.connect(
      Uri.parse(LiveApiConfig.websocketUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer AIzaSyDiADkvYGF5l0fRyjWLf9jp6mPfEZPQfAg"
      }
    );
    print("Starting socket");
    channel.stream.listen(
      (msg) => onMessage?.call(msg),
      onDone: () => onDisconnect?.call(),
      onError: (err) => onError?.call(err)
    );

    final msg = LiveApiMessage.setup(model: LiveApiConfig.model, prompt: LiveApiConfig.instructions).toJson();
    print(msg.toString());
    channel.sink.add(jsonEncode(msg));
  }

  void returnFunctionCall(Map<String, dynamic> msg) async {}

  void muteMic() {}

  void unmuteMic() {}

  void close() {}
}
