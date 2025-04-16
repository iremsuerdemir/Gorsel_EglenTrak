import 'package:flutter/material.dart';

class GradientBorder extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderWidth;
  final double padding;
  final Color? backgroundColor;
  final List<Color>? colors;
  final String? backgroundImage;

  const GradientBorder({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.borderWidth = 5,
    this.colors,
    this.padding = 10,
    this.backgroundColor,
    this.backgroundImage,
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
          color:
              backgroundColor ??
              Theme.of(
                context,
              ).colorScheme.surface, // 🔥 Eğer image varsa renk yok
          borderRadius: BorderRadius.circular(10),
          image:
              backgroundImage != null
                  ? DecorationImage(
                    image: NetworkImage(backgroundImage!), // URL'yi alır.
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
