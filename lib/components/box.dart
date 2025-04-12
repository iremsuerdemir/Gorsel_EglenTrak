import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';

class Box extends StatefulWidget {
  final Widget child;
  final double width;
  final Color? backgroundColor;
  final double borderwidth;
  final double padding;
  final List<Color>? colors;
  final Function onpressed;

  const Box({
    super.key,
    required this.child,
    required this.onpressed,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderwidth = 5,
    this.colors,
    this.padding = 10,
  });

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Hafif küçülme efekti
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Orijinal boyuta dön
    });
    widget.onpressed();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Parmağı kaldırınca normale dön
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: _scale),
        duration: const Duration(milliseconds: 100),
        builder: (context, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: GradientBorder(
              backgroundColor: widget.backgroundColor,
              borderWidth: widget.borderwidth,
              colors: widget.colors,
              padding: widget.padding,
              width: widget.width,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
