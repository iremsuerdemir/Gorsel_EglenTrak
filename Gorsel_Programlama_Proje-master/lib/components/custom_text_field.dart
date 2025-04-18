import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Color? color;
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? focusedColor;
  final Color? labelColor;
  final int height;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.color,
    this.enabledColor,
    this.disabledColor,
    this.focusedColor,
    this.labelColor,
    this.isPassword = false,
    this.height = 50,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.white),
          labelText: widget.label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color ?? Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.enabledColor ?? Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.disabledColor ?? Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.focusedColor ?? Colors.white),
          ),
          suffix:
              widget.isPassword
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecureText = !_obsecureText;
                      });
                    },
                    icon: Icon(
                      _obsecureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                  : SizedBox(),
        ),
        obscureText: widget.isPassword ? _obsecureText : false,
      ),
    );
  }
}
