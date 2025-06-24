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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateIndicators);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicators());
  }

  void _updateIndicators() {
    if (!_controller.hasClients) return;

    final hasBelow =
        _controller.position.pixels + 100 < _controller.position.maxScrollExtent;

    if (_hasMoreBelow != hasBelow) {
      setState(() {
        _hasMoreBelow = hasBelow;
      });
    }
  }

  void _scrollToBottom() {
    if (_controller.hasClients) {
      _controller.animateTo(
        _controller.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          child: widget.child,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: AnimatedOpacity(
            opacity: _hasMoreBelow ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _scrollToBottom,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
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
