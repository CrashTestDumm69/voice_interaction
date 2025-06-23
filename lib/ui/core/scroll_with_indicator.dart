import 'package:flutter/material.dart';

class ScrollWithIndicator extends StatefulWidget {
  final Widget child;
  
  const ScrollWithIndicator({super.key, required this.child});
  
  @override
  State<ScrollWithIndicator> createState() => _ScrollWithIndicatorState();
}

class _ScrollWithIndicatorState extends State<ScrollWithIndicator> {
  final ScrollController _controller = ScrollController();
  bool _hasMoreBelow = false;
  bool _hasMoreAbove = false;
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateIndicators);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicators());
  }
  
  void _updateIndicators() {
    if (!_controller.hasClients) return;
    
    final hasBelow = _controller.position.pixels < _controller.position.maxScrollExtent;
    final hasAbove = _controller.position.pixels > 0;
    
    if (_hasMoreBelow != hasBelow || _hasMoreAbove != hasAbove) {
      setState(() {
        _hasMoreBelow = hasBelow;
        _hasMoreAbove = hasAbove;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            SingleChildScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              child: widget.child,
            ),
            // Top gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 15,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _hasMoreAbove ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.98),
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.92),
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.8),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.6),
                        Colors.white.withValues(alpha: 0.4),
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 15,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _hasMoreBelow ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.98),
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.92),
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.8),
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.6),
                        Colors.white.withValues(alpha: 0.4),
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}