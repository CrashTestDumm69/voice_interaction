import 'package:flutter/material.dart';

class AnimatedOverlay extends StatelessWidget {
  final bool condition;
  final Duration duration;
  final Widget? child;

  const AnimatedOverlay({super.key, required this.condition, this.duration = const Duration(milliseconds: 300), required this.child});
  
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !condition,
      child: AnimatedOpacity(
        opacity: condition ? 1.0 : 0.0,
        duration: duration,
        child: child,
      ),
    );
  }
}