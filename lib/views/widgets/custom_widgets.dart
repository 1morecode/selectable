//
// Created by 1 More Code on 05/11/24.
//

import 'package:flutter/material.dart';

getFieldTitle(String title, context) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Text(
      title,
      style: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w500),
    ),
  );
}