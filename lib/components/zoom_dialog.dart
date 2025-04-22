import 'dart:ui';

import 'package:flutter/material.dart';

class ZoomDialog {
  static void show({required BuildContext context, required Image image}) {
    showDialog(
      context: context,
      builder:
          (context) => Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0, // X eksenindeki blur yoğunluğu
                  sigmaY: 5.0, // Y eksenindeki blur yoğunluğu
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent, // şeffaf overlay
                  ),
                ),
              ),
              Center(
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          image,
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: 0.7),
                                ),
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
