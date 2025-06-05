import 'package:go_router/go_router.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/interaction/widgets/interaction_screen.dart';
import 'package:voice_interaction/utils/injection_container.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.interaction,
  routes: [
    GoRoute(
      path: Routes.interaction,
      builder: (context, state) {
        return InteractionScreen(viewModel: sl());
      }
    )
  ]
);