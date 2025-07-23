import 'dart:async';

import 'package:dio/dio.dart';
import 'package:voice_interaction/data/services/live_api_service.dart';

void main() async {
  final Dio dio = Dio();
  final LiveApiService liveApiService = LiveApiService(dio: dio);

  liveApiService.initConnection("", onMessage: (msg) => print("Message - ${msg}"), onDisconnect: () => print("Disconnected"), onError: (err) => print("Error - $err"));

  await Completer<void>().future;
}