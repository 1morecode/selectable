// Created by 1 More Code on 04/11/24.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/helper/shared_preferences_helper.dart';
import 'package:selectable/views/admin/admin_dashboard.dart';
import 'package:selectable/views/auth/login_screen.dart';
import 'package:selectable/views/users/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Calling the navigate function after the splash screen is loaded
    navigate();
  }

  // Function to handle navigation after the splash screen
  navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      // Checking if the user is logged in and if user details are available
      if (FirebaseAuth.instance.currentUser != null &&
          PreferencesHelper.getUser() != null) {
        // If the user is an admin, navigate to the Admin Dashboard
        if (PreferencesHelper.getUser()['type'] == 'admin') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ),
                  (route) => false);  // Removing previous routes from the stack
        } else {
          // If the user is not an admin, navigate to the Home Screen
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
                  (route) => false);  // Removing previous routes from the stack
        }
      } else {
        // If the user is not logged in, navigate to the Login Screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
                (route) => false);  // Removing previous routes from the stack
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Displaying the logo image
              Image.asset(
                'assets/logo.png',
                width: size.width * 0.8,  // Setting width as 80% of the screen width
              ),
              const Text(
                "SelecTable",  // Title of the app
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
