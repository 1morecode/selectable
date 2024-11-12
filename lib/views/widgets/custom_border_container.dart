//
// Created by 1 More Code on 19/08/24.
//

import 'package:flutter/material.dart';

class CustomBorderedContainer extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final Color? bgColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const CustomBorderedContainer({super.key, required this.child, this.borderColor, this.bgColor, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: bgColor,
          border: Border.all(color: borderColor ?? colorScheme.onSurface, width: 1)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: child,
      ),
    );
  }
}
