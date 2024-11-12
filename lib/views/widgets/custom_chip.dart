//*************   © Copyrighted by 1 More Code. *********************

import 'package:flutter/material.dart';
import 'custom_card.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CustomChip({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CustomCard(
      radius: BorderRadius.circular(25),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 2),
        child: Text(
          text,
          style: style ?? TextStyle(
              color: colorScheme.secondaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }
}
