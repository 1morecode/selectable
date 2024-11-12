//
// Created by 1 More Code on 04/11/24.
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null && PreferencesHelper.getUser() != null) {
        if(PreferencesHelper.getUser()['type'] == 'admin'){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ),
                  (route) => false);
        }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
                  (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
