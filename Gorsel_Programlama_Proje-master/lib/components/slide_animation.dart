import 'package:flutter/widgets.dart';

class SlideAnimation extends StatefulWidget {
  final Widget child;
  final double startOffsetX;
  final double startOffsetY;
  final double endOffsetX;
  final double endOffsetY;
  final int milliseconds;
  final Curve curve;

  const SlideAnimation({
    super.key,
    required this.child,
    required this.startOffsetX,
    required this.startOffsetY,
    this.endOffsetX = 0,
    this.endOffsetY = 0,
    this.milliseconds = 600,
    this.curve = Curves.easeInOut,
  });

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milliseconds),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(
        widget.startOffsetX,
        widget.startOffsetY,
      ), // Ekranın dışından başlat
      end: Offset(widget.endOffsetX, widget.endOffsetY),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward(); // Animasyonu başlat
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
