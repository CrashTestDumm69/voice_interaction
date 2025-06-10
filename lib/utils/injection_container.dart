import 'package:get_it/get_it.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';

final GetIt sl = GetIt.instance;

void initializeDeps() {
  sl.registerSingleton(RealtimeApiService());
  sl.registerSingleton(PackageHandlerService());
  sl.registerSingleton(DepartmentHandlerService());
  sl.registerSingleton(DotenvService());
  sl.registerSingleton(RealtimeApiRepository(service: sl()));
  sl.registerSingleton(InteractionViewModel(repository: sl()));
}