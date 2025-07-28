import 'package:go_router/go_router.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/features/home/widgets/home_screen.dart';
import 'package:voice_interaction/ui/features/interaction/widgets/interaction_screen.dart';
import 'package:voice_interaction/ui/features/playlist/widgets/media_player_screen.dart';
import 'package:voice_interaction/ui/features/settings/widgets/settings_screen.dart';
import 'package:voice_interaction/ui/features/update/widgets/update_screen.dart';
import 'package:voice_interaction/utils/injection_container.dart';

GoRouter router({required String initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.interaction,
      builder: (context, state) => InteractionScreen(viewModel: sl())
    ),
    GoRoute(
      path: Routes.update,
      builder: (context, state) => UpdateScreen(viewModel: sl())
    ),
    GoRoute(
      path: Routes.mediaPlayer,
      builder: (context, state) => MediaPlayerScreen(viewModel: sl())
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => SettingsScreen(viewModel: sl())
    )
  ]
);