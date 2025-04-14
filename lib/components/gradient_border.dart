import 'package:flutter/material.dart';

class GradientBorder extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderWidth;
  final double padding;
  final Color? backgroundColor;
  final List<Color>? colors;
  const GradientBorder({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 30,
    this.borderWidth = 5,
    this.colors,
    this.padding = 10,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              colors ??
              [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
