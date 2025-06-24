import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/features/interaction/widgets/interaction_screen.dart';
import 'package:voice_interaction/ui/features/update/widgets/update_screen.dart';
import 'package:voice_interaction/utils/injection_container.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.interaction,
  routes: [
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
    )
  ]
);

CustomTransitionPage _buildSlideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: child,
      );
    },
  );
}