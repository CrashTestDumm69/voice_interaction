import 'package:flutter/material.dart';
import 'package:voice_interaction/ui/core/details_widget_theme.dart';

class DetailsContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClose;
  final double maxContentWidth;
  final double maxContentHeight;
  final double borderRadius;

  const DetailsContainer({
    super.key,
    required this.child,
    this.onClose,
    this.maxContentWidth = DetailsWidgetTheme.maxContentWidth,
    this.maxContentHeight = DetailsWidgetTheme.maxContentHeight,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: DetailsWidgetTheme.backgroundOpacity),
      child: Stack(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth, maxHeight: maxContentHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(DetailsWidgetTheme.contentPadding),
                    child: child,
                  ),
                  if (onClose != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: onClose,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}