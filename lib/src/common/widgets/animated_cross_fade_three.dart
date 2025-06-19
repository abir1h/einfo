import 'package:flutter/material.dart';
class AnimatedCrossFadeThree extends StatefulWidget {
  const AnimatedCrossFadeThree({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.thirdChild,
    required this.crossFadeState,
    required this.duration,
    this.curve = Curves.linear,
    this.alignment = Alignment.topCenter,
  });

  final Widget firstChild;
  final Widget secondChild;
  final Widget thirdChild;
  final CrossFadeThreeState crossFadeState;
  final Duration duration;
  final Curve curve;
  final AlignmentGeometry alignment;

  @override
  State<AnimatedCrossFadeThree> createState() => _AnimatedCrossFadeThreeState();
}

class _AnimatedCrossFadeThreeState extends State<AnimatedCrossFadeThree> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _setupAnimations();
    _updateIndex();
  }

  void _setupAnimations() {
    _fadeAnimations = List.generate(3, (_) => _controller.drive(CurveTween(curve: widget.curve)));
  }

  void _updateIndex() {
    _currentIndex = widget.crossFadeState.index;
  }

  @override
  void didUpdateWidget(covariant AnimatedCrossFadeThree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.crossFadeState.index != _currentIndex) {
      _controller.forward(from: 0.0).then((_) {
        setState(() {
          _updateIndex();
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFade(int index, Widget child) {
    final isCurrent = index == _currentIndex;
    return FadeTransition(
      opacity: _controller.drive(
        Tween<double>(
          begin: isCurrent ? 0.0 : 1.0,
          end: isCurrent ? 1.0 : 0.0,
        ).chain(CurveTween(curve: widget.curve)),
      ),
      child: IgnorePointer(
        ignoring: !isCurrent,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.duration,
      alignment: widget.alignment,
      curve: widget.curve,
      child: Stack(
        children: [
          _buildFade(0, widget.firstChild),
          _buildFade(1, widget.secondChild),
          _buildFade(2, widget.thirdChild),
        ],
      ),
    );
  }
}

enum CrossFadeThreeState {
  showFirst,
  showSecond,
  showThird,
}
