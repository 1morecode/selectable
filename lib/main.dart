import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/admin/a_booking_provider.dart';
import 'package:selectable/provider/admin/a_restaurant_provider.dart';
import 'package:selectable/provider/admin/admin_provider.dart';
import 'package:selectable/provider/auth_provider.dart';
import 'package:selectable/provider/booking_provider.dart';
import 'package:selectable/provider/home_provider.dart';
import 'package:selectable/provider/restaurant_provider.dart';
import 'package:selectable/splash_screen.dart';
import 'package:selectable/theme/app_state.dart';
import 'package:selectable/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'helper/global_data.dart';
import 'helper/shared_preferences_helper.dart';

// Global variables
bool? themeMode = false; // Variable to store the theme mode (light or dark)
Logger logger = Logger(); // Logger instance for logging debug information

// The entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase initialization with platform-specific options
  );

  // Initialize shared preferences
  PreferencesHelper.preferences = await SharedPreferences.getInstance();

  // Override HTTP settings to allow insecure certificates (useful for development purposes)
  HttpOverrides.global = MyHttpOverrides();

  // Run the app wrapped in a MultiProvider to provide various services
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Admin Providers
        ChangeNotifierProvider<ARestaurantProvider>(
          create: (_) => ARestaurantProvider(),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (_) => AdminProvider(),
        ),
        ChangeNotifierProvider<ABookingProvider>(
          create: (_) => ABookingProvider(),
        ),
        // User Providers
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(),
        ),
      ],
      child: const MyApp(), // Main App widget
    ),
  );
}

// Function to check and apply the theme mode from shared preferences
checkTheme() {
  if (PreferencesHelper.preferences.containsKey("themeMode")) {
    themeMode = PreferencesHelper.preferences.getBool("themeMode");
    if (themeMode!) {
      // Apply dark theme if themeMode is true
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
    } else {
      // Apply light theme if themeMode is false
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark));
    }
  } else {
    // Apply default light theme
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }
}

// The main widget that builds the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer widget to rebuild the UI based on the app state (e.g., dark mode)
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Set the system UI overlay style based on the current theme mode
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: appState.isDarkModeOn
                ? AppTheme.darkTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        );

        // Configure EasyLoading settings (used for loading indicators)
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = appState.isDarkModeOn
              ? EasyLoadingStyle.dark
              : EasyLoadingStyle.light
          ..indicatorSize = 30.0
          ..radius = 10.0
          ..progressColor = Colors.yellow
          ..backgroundColor = Colors.green
          ..indicatorColor = Colors.yellow
          ..textColor = Colors.yellow
          ..maskColor = Colors.blue.withOpacity(0.5)
          ..userInteractions = true
          ..dismissOnTap = false;

        // Return the MaterialApp widget that holds the entire app
        return MaterialApp(
          navigatorKey: navigatorKey, // Global navigator key for navigation control
          debugShowCheckedModeBanner: false, // Disable the debug banner in the app
          title: 'Court Book', // Title of the app
          theme: AppTheme.lightTheme, // Light theme
          darkTheme: AppTheme.darkTheme, // Dark theme
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light, // Choose theme mode based on app state
          color: Colors.blue, // Primary color for the app
          home: const SplashScreen(), // Set the initial screen to SplashScreen
          builder: EasyLoading.init(), // Initialize EasyLoading
        );
      },
    );
  }
}

// Custom HTTP override class to allow insecure SSL certificates (for development purposes)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // Accept all certificates
  }
}
