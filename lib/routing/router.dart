import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/features/actions/widgets/actions_screen.dart';
import 'package:voice_interaction/ui/features/home/widgets/home_screen.dart';
import 'package:voice_interaction/ui/features/interaction/widgets/interaction_screen.dart';
import 'package:voice_interaction/ui/features/playlist/widgets/media_player_screen.dart';
import 'package:voice_interaction/ui/features/update/widgets/update_screen.dart';
import 'package:voice_interaction/utils/injection_container.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.interaction,
      pageBuilder: (context, state) {
        return _buildSlideUpPage(
          key: state.pageKey,
          child: InteractionScreen(viewModel: sl())
        );
      }
    ),
    GoRoute(
      path: Routes.update,
      pageBuilder: (context, state) {
        return _buildSlideUpPage(
          key: state.pageKey,
          child: UpdateScreen(viewModel: sl())
        );
      }
    ),
    GoRoute(
      path: Routes.mediaPlayer,
      pageBuilder: (context, state) {
        return _buildSlideUpPage(
          key: state.pageKey,
          child: MediaPlayerScreen(viewModel: sl())
        );
      }
    ),
    GoRoute(
      path: Routes.actions,
      pageBuilder: (context, state) {
        return _buildSlideUpPage(
          key: state.pageKey,
          child: ActionsScreen(viewModel: sl())
        );
      }
    ),
  ]
);

CustomTransitionPage _buildSlideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      final slideTween = Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      );

      return SlideTransition(
        position: curvedAnimation.drive(slideTween),
        child: ScaleTransition(
          scale: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}