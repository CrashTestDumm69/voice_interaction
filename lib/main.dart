import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/routing/router.dart';
import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/update/view_model/update_view_model.dart';
import 'package:voice_interaction/utils/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  sl<UpdateViewModel>().add(StartUpdateCheck());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateViewModel, UpdateState>(
      bloc: sl(),
      listenWhen: (prev, curr) => curr is UpdateAvailable,
      listener: (context, state) {
        if (state is UpdateAvailable) {
          context.go(Routes.update);
        }
      },
      child: MaterialApp.router(
        routerConfig: router()
      )
    );
  }
}