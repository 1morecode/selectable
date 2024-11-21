import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = MyColors.darkBlue;
  static const Color _lightPrimaryVariantColor = MyColors.lightBlue;
  static const Color _lightOnPrimaryColor = MyColors.white;
  static const Color _lightSecondaryColor = MyColors.red;
  static const Color _lightGreyColor = MyColors.lightGrey;
  static const Color _lightBrightColor = MyColors.darkGrey;
  static const Color _lightTextColor = MyColors.black;
  static const Color _lightTextVariantColor = MyColors.lightBlack;
  static const Color _lightSecondaryContainer = MyColors.lightSecondary;
  static const Color _lightOnSecondaryContainer = MyColors.lightOnSecondary;

  static const TextStyle _lightScreenHeadingTextStyle =
      TextStyle(fontSize: 20.0, color: _lightPrimaryVariantColor);
  static const TextStyle _lightSubHeadingTextStyle =
      TextStyle(fontSize: 18.0, color: _lightBrightColor);
  static const TextStyle _lightAppBarHeadingTextStyle = TextStyle(
      fontSize: 20.0, color: _lightOnPrimaryColor, fontWeight: FontWeight.w700);
  static const TextStyle _lightScreenTaskNameTextStyle = TextStyle(
      fontSize: 20.0,
      color: _lightTextVariantColor,
      fontWeight: FontWeight.w300);
  static const TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16.0, color: _lightTextColor);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightOnPrimaryColor,
    inputDecorationTheme:
        const InputDecorationTheme(fillColor: _lightPrimaryColor),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder()
    }),
    appBarTheme: const AppBarTheme(
        // brightness: Brightness.light,
        titleSpacing: 10,
        iconTheme: IconThemeData(
          color: _lightOnSecondaryContainer,
        ),
        titleTextStyle: TextStyle(
            color: _lightOnSecondaryContainer,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        backgroundColor: _lightOnPrimaryColor,
        shadowColor: _lightGreyColor,
        scrolledUnderElevation: 0.2,
        elevation: 0.1,
        surfaceTintColor: _lightOnPrimaryColor),
    cupertinoOverrideTheme: const CupertinoThemeData(
        barBackgroundColor: _lightOnPrimaryColor,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(primaryColor: _lightPrimaryColor),
        primaryColor: _lightPrimaryColor),
    iconTheme: const IconThemeData(color: _lightPrimaryColor, size: 24),
    textTheme: _lightTextTheme,
    disabledColor: _lightBrightColor,
    dialogBackgroundColor: _lightPrimaryVariantColor,
    // accentColor: _lightPrimaryColor,
    cardTheme: const CardTheme(elevation: 2, color: _lightOnPrimaryColor),
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.grey.withOpacity(0.3),
    colorScheme: const ColorScheme.light(
            primary: _lightPrimaryColor,
            secondary: _lightSecondaryColor,
            primaryContainer: _lightPrimaryVariantColor,
            onPrimary: _lightOnPrimaryColor,
            onSecondary: _lightTextColor,
            background: _lightPrimaryColor,
            secondaryContainer: _lightSecondaryContainer,
            onSecondaryContainer: _lightOnSecondaryContainer,
            surface: _lightGreyColor,
            onSurface: _lightGreyColor,
            brightness: Brightness.dark)
        .copyWith(background: _lightOnPrimaryColor),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headlineSmall: _lightScreenHeadingTextStyle,
    bodyMedium: _lightScreenTaskNameTextStyle,
    bodyLarge: _lightScreenTaskDurationTextStyle,
    headlineLarge: _lightAppBarHeadingTextStyle,
    titleMedium: _lightScreenHeadingTextStyle,
    headlineMedium: _lightSubHeadingTextStyle,
    titleSmall: _lightScreenTaskDurationTextStyle,
  );

  // Dark Theme
  static const Color _darkPrimaryColor = MyColors.lightGrey;
  static const Color _darkPrimaryVariantColor = Colors.blue;
  static const Color _darkOnPrimaryColor = MyColors.darkThemeBlack;
  static const Color _darkSecondaryColor = MyColors.red;
  static const Color _darkGreyColor = MyColors.lightBlack;
  static const Color _darkBrightColor = MyColors.lightBlack;
  static const Color _darkTextColor = MyColors.white;
  static const Color _darkTextVariantColor = MyColors.lightGrey;
  static const Color _darkSecondaryContainer = MyColors.darkSecondary;

  static const TextStyle _darkScreenHeadingTextStyle =
      TextStyle(fontSize: 32.0, color: _darkPrimaryVariantColor);
  static const TextStyle _darkSubHeadingTextStyle =
      TextStyle(fontSize: 18.0, color: _darkTextVariantColor);
  static const TextStyle _darkAppBarHeadingTextStyle = TextStyle(
      fontSize: 20.0, color: _darkTextColor, fontWeight: FontWeight.w700);
  static const TextStyle _darkScreenTaskNameTextStyle = TextStyle(
      fontSize: 20.0,
      color: _darkTextVariantColor,
      fontWeight: FontWeight.w500);
  static const TextStyle _darkScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16.0, color: _darkTextColor);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkOnPrimaryColor,
    inputDecorationTheme:
        const InputDecorationTheme(fillColor: _darkPrimaryColor),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    appBarTheme: const AppBarTheme(
        // brightness: Brightness.dark,
      titleSpacing: 10,
        backgroundColor: _darkOnPrimaryColor,
        iconTheme: IconThemeData(
          color: _darkPrimaryColor,
        ),
        titleTextStyle: TextStyle(
            color: _darkPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        elevation: 1),
    cupertinoOverrideTheme: const CupertinoThemeData(
        barBackgroundColor: _darkOnPrimaryColor,
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(primaryColor: _darkPrimaryColor),
        primaryColor: _darkPrimaryColor),
    iconTheme: const IconThemeData(color: _darkPrimaryColor, size: 24),
    textTheme: _darkTextTheme,
    disabledColor: _darkBrightColor,
    dialogBackgroundColor: _darkPrimaryVariantColor,
    // accentColor: _darkPrimaryColor,
    cardTheme: const CardTheme(elevation: 2, color: _darkOnPrimaryColor),
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.grey.withOpacity(0.3),
    colorScheme: const ColorScheme.dark(
            primary: _darkPrimaryColor,
            // primaryVariant: _darkPrimaryVariantColor,
            secondary: _darkSecondaryColor,
            primaryContainer: _darkPrimaryVariantColor,
            onPrimary: _darkOnPrimaryColor,
            onSecondary: _darkTextColor,
            secondaryContainer: _darkSecondaryContainer,
            background: _darkPrimaryColor,
            surface: _darkGreyColor,
            onSurface: _darkGreyColor,
            brightness: Brightness.light)
        .copyWith(background: _darkOnPrimaryColor),
  );

  static const TextTheme _darkTextTheme = TextTheme(
      headlineSmall: _darkScreenHeadingTextStyle,
      bodyMedium: _darkScreenTaskNameTextStyle,
      bodyLarge: _darkScreenTaskDurationTextStyle,
      headlineLarge: _darkAppBarHeadingTextStyle,
      titleMedium: _darkScreenHeadingTextStyle,
      headlineMedium: _darkSubHeadingTextStyle,
      titleSmall: _darkScreenTaskDurationTextStyle);
}
