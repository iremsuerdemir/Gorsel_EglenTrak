import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
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
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _scale = 1.0; // Başlangıç boyutu

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.95; // Butona basıldığında küçülme oranı
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0; // Buton bırakıldığında eski boyutuna döner
        });
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0; // Buton iptal edildiğinde eski boyutuna döner
        });
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 100), // Animasyon süresi
        curve: Curves.easeInOut, // Animasyon eğrisi
        scale: _scale, // Butonun boyutu
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.color ?? Theme.of(context).primaryColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.icon != null)
                Positioned(
                  left: 8,
                  child: SizedBox(width: 30, child: widget.icon),
                ),
              Center(
                child: Text(
                  widget.text,
                  style:
                      widget.textStyle ??
                      Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
