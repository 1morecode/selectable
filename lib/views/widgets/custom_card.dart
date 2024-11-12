//*************   © Copyrighted by 1 More Code. *********************

import 'dart:ui';

import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  final Widget child;
  final BorderRadius? radius;
  final Color? borderColor;
  final double opacity;

  const CustomCard({super.key, required this.child, this.radius, this.opacity = 0.2, this.borderColor});

  @override
  Widget build(BuildContext context) {
    bool bordered = true;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(opacity),
              border: Border.all(
                  color: bordered == true ? (borderColor ?? colorScheme.onSurface) : Colors.transparent,
                  width: bordered == true ? 1 : 0),
              borderRadius: radius ?? BorderRadius.circular(6),
            ),
            child: child),
      ),
    );
  }
}
