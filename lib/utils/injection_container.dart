import 'package:get_it/get_it.dart';
import 'package:voice_interaction/data/repositories/department_repository.dart';
import 'package:voice_interaction/data/repositories/doctor_repository.dart';
import 'package:voice_interaction/data/repositories/package_repository.dart';

import 'package:voice_interaction/data/repositories/realtime_api_repository.dart';
import 'package:voice_interaction/data/repositories/update_repository.dart';
import 'package:voice_interaction/data/repositories/volume_repositroy.dart';
import 'package:voice_interaction/data/services/department_handler_service.dart';
import 'package:voice_interaction/data/services/doctor_handler_service.dart';
import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/native_volume_handler_service.dart';
import 'package:voice_interaction/data/services/package_handler_service.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/data/services/realtime_api_tools_service.dart';
import 'package:voice_interaction/data/services/update_service.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/update/view_model/update_view_model.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDeps() async {
  sl.registerSingleton(UpdateService());
  sl.registerSingleton(UpdateRepository(updateService: sl()));
  sl.registerSingleton(UpdateViewModel(updateRepository: sl()));

  sl.registerSingleton(NativeVolumeHandlerService());
  sl.registerSingleton(VolumeRepositroy(nativeVolumeHandlerService: sl()));

  sl.registerSingleton(PackageHandlerService());
  await sl<PackageHandlerService>().loadPackages();
  sl.registerSingleton(PackageRepository(packageHandlerService: sl()));

  sl.registerSingleton(DepartmentHandlerService());
  await sl<DepartmentHandlerService>().loadDepartments();
  sl.registerSingleton(DepartmentRepository(departmentHandlerService: sl()));

  sl.registerSingleton(DoctorHandlerService());
  await sl<DoctorHandlerService>().loadDoctors();
  sl.registerSingleton(DoctorRepository(doctorHandlerService: sl()));

  sl.registerSingleton(DotenvService());
  await sl<DotenvService>().loadEnv();

  sl.registerSingleton(RealtimeApiToolsService(packageHandlerService: sl(), departmentHandlerService: sl()));
  sl<RealtimeApiToolsService>().loadTools();

  sl.registerSingleton(RealtimeApiService(realtimeApiToolsService: sl()));
  sl.registerSingleton(RealtimeApiRepository(realtimeApiService: sl(), dotenvService: sl()));

  sl.registerSingleton(
    InteractionViewModel(
      volumeRepository: sl(),
      realtimeApiRepository: sl(),
      packageRepository: sl(),
      departmentRepository: sl(),
      doctorRepository: sl(),
    ),
  );
}
