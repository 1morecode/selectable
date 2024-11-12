//
// Created by 1 More Code on 10/11/24.
//

import 'package:flutter/material.dart';

class SmallHeading extends StatelessWidget {
  final String text;
  const SmallHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(text, style: TextStyle(color: colorScheme.onSecondary, fontSize: 14, fontWeight: FontWeight.w600),),
    );
  }
}
