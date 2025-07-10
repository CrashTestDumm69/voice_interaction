import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:voice_interaction/data/repositories/playlist_repository.dart';
import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/repositories/update_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';
import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/face_detector_service.dart';
import 'package:voice_interaction/data/services/native_volume_handler_service.dart';
import 'package:voice_interaction/data/services/playlist_api_service.dart';
import 'package:voice_interaction/data/services/playlist_storage_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/data/services/realtime_api_tools_service.dart';
import 'package:voice_interaction/data/services/update_service.dart';
import 'package:voice_interaction/ui/features/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/features/playlist/view_model/media_player_view_model.dart';
import 'package:voice_interaction/ui/features/update/view_model/update_view_model.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDeps() async {
  // Dio
  sl.registerSingleton(Dio());

  // Face detector
  sl.registerSingleton(FaceDetectorService());

  // Update
  sl.registerSingleton(UpdateService(dio: sl()));
  sl.registerSingleton(UpdateRepository(updateService: sl()));
  sl.registerSingleton(UpdateViewModel(updateRepository: sl()));

  // Volume handler
  sl.registerSingleton(NativeVolumeHandlerService());
  sl.registerSingleton(VolumeRepositroy(nativeVolumeHandlerService: sl()));

  // Dotenv
  sl.registerSingleton(DotenvService());
  await sl<DotenvService>().loadEnv();

  // Realtime Api
  sl.registerSingleton(RealtimeApiToolsService(volumeHandlerService: sl()));
  sl<RealtimeApiToolsService>().loadTools();
  sl.registerSingleton(RealtimeApiService(realtimeApiToolsService: sl(), dio: sl()));
  sl.registerSingleton(RealtimeApiRepository(realtimeApiService: sl(), dotenvService: sl()));
  sl.registerSingleton(InteractionViewModel(volumeRepository: sl(), realtimeApiRepository: sl()));

  // Platform playlists
  sl.registerSingleton(PlaylistApiService(dio: sl()));
  sl.registerSingleton(PlaylistStorageService(dio: sl()));
  await sl<PlaylistStorageService>().initService();
  sl.registerSingleton(PlaylistRepository(playlistApiService: sl(), playlistStorageService: sl()));
  await sl<PlaylistRepository>().loadPlaylists();
  sl.registerSingleton(MediaPlayerViewModel(playlistRepository: sl()));
}
