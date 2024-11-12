//
// Created by 1 More Code on 05/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:selectable/helper/alerts.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/helper/shared_preferences_helper.dart';
import 'package:selectable/main.dart';
import 'package:selectable/views/admin/admin_dashboard.dart';
import 'package:selectable/views/auth/login_screen.dart';
import 'package:selectable/views/users/home_screen.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  User? get user => _auth.currentUser;

  clearFields() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    notifyListeners();
  }

  loginValid() {
    if (!emailRegExp.hasMatch(emailController.text.trim())) {
      errorAlert(text: "Enter Valid Email");
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorAlert(text: "Enter Password");
      return false;
    }
    return true;
  }

  signUpValid() {
    if (nameController.text.isEmpty) {
      errorAlert(text: "Enter Name");
      return false;
    }
    if (!emailRegExp.hasMatch(emailController.text.trim())) {
      errorAlert(text: "Enter Valid Email");
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorAlert(text: "Enter Password");
      return false;
    }
    return true;
  }

  Future<void> signIn() async {
    try {
      if (loginValid()) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
          if (userDoc.exists && userDoc.get('type') == 'admin') {
            failedAlert(text: "Enter valid credentials!");
            _auth.signOut();
            return ;
          } else if (userDoc.exists) {
            PreferencesHelper.saveUser(userDoc.data());
          } else {
            var data = {
              "uid": userCredential.user!.uid,
              "email": emailController.text.trim(),
              "name": "New User",
              "photoUrl": GlobalData.defaultAvatar,
              "type": "user",
              "createdAt": DateTime.now().millisecondsSinceEpoch,
              "updatedAt": DateTime.now().millisecondsSinceEpoch
            };
            firebaseFirestore
                .collection("users")
                .doc(userCredential.user!.uid)
                .set(data);
            PreferencesHelper.saveUser(data);
          }
          clearFields();
          successAlert(text: "Logged In!");
          Navigator.pushAndRemoveUntil(
              globalContext(),
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        } else {
          failedAlert(text: "Enter valid credentials!");
        }
        notifyListeners();
      }
    } catch (e) {
      logger.i(e);
      if (e.toString().contains('credential is incorrect')) {
        failedAlert(text: "Enter valid credentials!");
      } else {
        failedAlert(text: "Failed to Login!");
      }
      rethrow;
    }
  }

  Future<void> signUp() async {
    try {
      if (signUpValid()) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text);
        if (userCredential.user != null) {
          var data = {
            "uid": userCredential.user!.uid,
            "email": emailController.text.trim(),
            "name": nameController.text,
            "photoUrl": GlobalData.defaultAvatar,
            "type": "user",
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "updatedAt": DateTime.now().millisecondsSinceEpoch
          };
          firebaseFirestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .set(data);
          PreferencesHelper.saveUser(data);
          notifyListeners();
          successAlert(text: "Registered Successfully!");
          Navigator.pushAndRemoveUntil(
              globalContext(),
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      failedAlert(text: "Failed to Register!");
      rethrow;
    }
  }

  Future<void> adminSignIn() async {
    try {
      if (loginValid()) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
          if (userDoc.exists && userDoc.get('type') == 'admin') {
            PreferencesHelper.saveUser(userDoc.data());
            clearFields();
            successAlert(text: "Logged In!");
            Navigator.pushAndRemoveUntil(
                globalContext(),
                MaterialPageRoute(
                  builder: (context) => const AdminDashboard(),
                ),
                    (route) => false);
          } else {
            _auth.signOut();
            failedAlert(text: "Enter valid credentials!");
          }
        } else {
          failedAlert(text: "Enter valid credentials!");
        }
        notifyListeners();
      }
    } catch (e) {
      logger.i(e);
      if (e.toString().contains('credential is incorrect')) {
        failedAlert(text: "Enter valid credentials!");
      } else {
        failedAlert(text: "Failed to Login!");
      }
      rethrow;
    }
  }

  getUser() async {
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (userDoc.exists) {
      PreferencesHelper.saveUser(userDoc.data());
    }
    notifyListeners();
  }

  updateUser(dynamic data) async {
    await firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update(data);
    getUser();
  }

  signOut() {
    customCupertinoAlert(
        title: Text(
          "Warning",
          style: TextStyle(color: Theme.of(globalContext()).colorScheme.error),
        ),
        content: "Do you really want to logout?",
        onPressed: () {
          _auth.signOut().then((value) {
            clearFields();
            PreferencesHelper.removeUser();
            notifyListeners();
            Navigator.pushAndRemoveUntil(
                globalContext(),
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
          });
        });
  }
}
