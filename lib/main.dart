import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

import 'package:voice_interaction/config/platform_api_data.dart';
import 'package:voice_interaction/data/repositories/face_detector_repository.dart';
import 'package:voice_interaction/data/repositories/live_api_repository.dart';
import 'package:voice_interaction/routing/router.dart';
import 'package:voice_interaction/utils/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light
  ));

  await initializeDeps();
  await PlatformApiData.init();

  // _handleFaceDetection();

  runApp(const MyApp());
}

void _handleFaceDetection() async {
  final faceRepo = sl<FaceDetectorRepository>();
  final realtimeRepo = sl<LiveApiRepository>();
  await faceRepo.initCamera();
  await faceRepo.startDetection();

  faceRepo.faceStream.listen((faceDetected) async {
    if (faceDetected) {
      debugPrint("Face detected");
      await realtimeRepo.startSession(
        onSpeak: () => debugPrint("Speaking"),
        onListen: () => debugPrint("Listening"),
        onConnect: () => debugPrint("Connected"),
        onDisconnect: () => debugPrint("Disconnected"),
        onFunctionCall: null
      );
    } else {
      debugPrint("Face lost");
      realtimeRepo.closeSession();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router()
    );
  }
}