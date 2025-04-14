import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Icon? icon;
  final String text;
  final TextStyle? textStyle;
  const CustomButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.color,
    this.icon,
    this.textStyle,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color ?? Theme.of(context).primaryColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (icon != null)
              Positioned(left: 8, child: SizedBox(width: 30, child: icon)),
            Center(
              child: Text(
                text,
                style:
                    textStyle ??
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium, // okunabilirlik için
              ),
            ),
          ],
        ),
      ),
    );
  }
}
