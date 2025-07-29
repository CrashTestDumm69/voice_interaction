import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:voice_interaction/config/platform_api_data.dart';

import 'package:voice_interaction/data/repositories/face_detector_repository.dart';
import 'package:voice_interaction/data/repositories/gemini_tts_repository.dart';
import 'package:voice_interaction/data/repositories/playlist_repository.dart';
import 'package:voice_interaction/data/repositories/live_api_repository.dart';
import 'package:voice_interaction/data/repositories/settings_repository.dart';
import 'package:voice_interaction/data/repositories/update_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';

import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/face_detector_service.dart';
import 'package:voice_interaction/data/services/gemini_tts_service.dart';
import 'package:voice_interaction/data/services/native_volume_handler_service.dart';
import 'package:voice_interaction/data/services/playlist_api_service.dart';
import 'package:voice_interaction/data/services/playlist_storage_service.dart';
import 'package:voice_interaction/data/services/live_api_service.dart';
import 'package:voice_interaction/data/services/settings_storage_service.dart';
import 'package:voice_interaction/data/services/update_service.dart';

import 'package:voice_interaction/ui/features/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/features/playlist/view_model/media_player_view_model.dart';
import 'package:voice_interaction/ui/features/settings/view_model/settings_view_model.dart';
import 'package:voice_interaction/ui/features/tts/view_model/tts_view_model.dart';
import 'package:voice_interaction/ui/features/update/view_model/update_view_model.dart';

import 'package:voice_interaction/utils/hive_registrar.g.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDeps() async {
  await PlatformApiData.init();
  final directory = await getApplicationSupportDirectory();
  Hive
    ..init("${directory.path}/boxes")
    ..registerAdapters();

  // Dio
  sl.registerSingleton(Dio());

  // Face detector
  sl.registerSingleton(FaceDetectorService());
  sl.registerSingleton(FaceDetectorRepository(faceDetectorService: sl()));

  // Update
  sl.registerSingleton(UpdateService(dio: sl()));
  sl.registerSingleton(UpdateRepository(updateService: sl()));
  sl.registerSingleton(UpdateViewModel(updateRepository: sl()));

  // Volume handler
  sl.registerSingleton(NativeVolumeHandlerService());
  sl.registerSingleton(VolumeRepositroy(nativeVolumeHandlerService: sl()));

  // Dotenv
  final dotenv = sl.registerSingleton(DotenvService());
  await dotenv.loadEnv();

  // Live Api
  sl.registerSingleton(LiveApiService());
  sl.registerSingleton(LiveApiRepository(liveApiService: sl(), dotenvService: sl()));
  sl.registerSingleton(InteractionViewModel(volumeRepository: sl(), liveApiRepository: sl()));

  // Platform playlists
  sl.registerSingleton(PlaylistApiService(dio: sl()));
  sl.registerSingleton(PlaylistStorageService(dio: sl()));
  final playlistRepo = sl.registerSingleton(PlaylistRepository(playlistApiService: sl(), playlistStorageService: sl()));
  await playlistRepo.init();
  sl.registerSingleton(MediaPlayerViewModel(playlistRepository: sl()));

  // Settings
  sl.registerSingleton(SettingsStorageService());
  final settingsRepo = sl.registerSingleton(SettingsRepository(settingsStorageService: sl()));
  await settingsRepo.init();
  sl.registerSingleton(SettingsViewModel(settingsRepository: sl()));

  // TTS
  sl.registerSingleton(GeminiTtsService(dio: sl()));
  final ttsRepo = sl.registerSingleton(GeminiTtsRepository(geminiTtsService: sl(), dotenvService: sl()));
  await ttsRepo.init();
  sl.registerSingleton(TtsViewModel(geminiTtsRepository: sl()));
}
