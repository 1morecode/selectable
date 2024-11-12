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
import 'package:selectable/provider/home_provider.dart';
import 'package:selectable/provider/restaurant_provider.dart';
import 'package:selectable/splash_screen.dart';
import 'package:selectable/theme/app_state.dart';
import 'package:selectable/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'helper/global_data.dart';
import 'helper/shared_preferences_helper.dart';

bool? themeMode = false;
Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PreferencesHelper.preferences = await SharedPreferences.getInstance();

  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Admin
        ChangeNotifierProvider<ARestaurantProvider>(
          create: (_) => ARestaurantProvider(),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (_) => AdminProvider(),
        ),
        ChangeNotifierProvider<ABookingProvider>(
          create: (_) => ABookingProvider(),
        ),
        // User
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

checkTheme() {
  if (PreferencesHelper.preferences.containsKey("themeMode")) {
    themeMode = PreferencesHelper.preferences.getBool("themeMode");
    if (themeMode!) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark));
    }
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: appState.isDarkModeOn
                ? AppTheme.darkTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        );

        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = appState.isDarkModeOn ? EasyLoadingStyle.dark : EasyLoadingStyle.light
          ..indicatorSize = 30.0
          ..radius = 10.0
          ..progressColor = Colors.yellow
          ..backgroundColor = Colors.green
          ..indicatorColor = Colors.yellow
          ..textColor = Colors.yellow
          ..maskColor = Colors.blue.withOpacity(0.5)
          ..userInteractions = true
          ..dismissOnTap = false;

        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Court Book',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          color: Colors.blue,
          home: const SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
