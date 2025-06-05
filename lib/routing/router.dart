import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/health_package/widgets/package_details_screen.dart';
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