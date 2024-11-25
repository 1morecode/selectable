//
// Created by 1 More Code on 05/11/24.
//

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instance; // Firestore instance

  // Controllers for managing input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isUserLoginLoading = false;
  bool isUserRegistrationLoading = false;
  bool isAdminLoginLoading = false;
  bool isUpdateLoading = false;

  bool isPhotoLoading = false; // Flag to indicate photo upload progress

  // Getter to retrieve the current user
  User? get user => _auth.currentUser;

  // Clears all input fields
  clearFields() {
    phoneController.clear();
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    notifyListeners(); // Notify listeners of the change
  }

  // Validates the login form fields
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

  // Validates the sign-up form fields
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

  // Validates the profile update fields
  updateValid() {
    if (nameController.text.isEmpty) {
      errorAlert(text: "Enter Name");
      return false;
    }
    if (!phoneSingaporeRegExp.hasMatch(phoneController.text.trim())) {
      errorAlert(text: "Enter Valid Phone");
      return false;
    }
    return true;
  }

  // Initializes the update form fields with the current user's data
  initUpdate() {
    dynamic user = PreferencesHelper.getUser(); // Retrieve stored user data
    if (user != null) {
      nameController.text = user['name'];
      phoneController.text = user['phone'];
    }
    notifyListeners(); // Notify listeners of the change
  }

  // Updates the user's profile data in Firestore
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      if (updateValid()) {
        isUpdateLoading = true;
        notifyListeners();
        await firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data);
        successAlert(text: "Profile Updated");
        getUser(); // Refresh user data
        isUpdateLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      logger.e(e); // Log the error
    }
    isUpdateLoading = false;
    notifyListeners();
    return false;
  }

  // Updates the user's profile photo in Firebase Storage
  Future<String?> updatePhoto({required File file}) async {
    try {
      isPhotoLoading = true;
      notifyListeners(); // Notify listeners that photo upload is in progress

      // Reference to the user's profile photo path in Firebase Storage
      Reference reference = FirebaseStorage.instance.ref().child(
          '+PROFILE_PHOTO/${FirebaseAuth.instance.currentUser!.uid}/my_photo.png');
      TaskSnapshot taskSnapshot = await reference.putFile(file); // Upload photo
      String url =
          await taskSnapshot.ref.getDownloadURL(); // Retrieve photo URL

      logger.i("URL: $url");
      isPhotoLoading = false;
      notifyListeners(); // Notify listeners that upload is complete
      return url;
    } catch (e) {
      logger.e(e); // Log the error
      isPhotoLoading = false;
      notifyListeners();
    }
    return null;
  }

  // Handles user login
  Future<void> signIn() async {
    try {
      if (loginValid()) {
        isUserLoginLoading = true;
        notifyListeners();
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
        isUserLoginLoading = false;
        notifyListeners();
        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists && userDoc.get('type') == 'admin') {
            failedAlert(text: "Enter valid credentials!");
            _auth.signOut();
            return;
          } else if (userDoc.exists) {
            PreferencesHelper.saveUser(
                userDoc.data()); // Save user data locally
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
                .set(data); // Save new user data in Firestore
            PreferencesHelper.saveUser(data);
          }

          clearFields(); // Clear input fields
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
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      if (e.code == 'user-not-found') {
        failedAlert(text: "No account found for this email.");
      } else if (e.code == 'wrong-password') {
        failedAlert(text: "Incorrect password. Please try again.");
      } else if (e.code == 'too-many-requests') {
        failedAlert(text: "Too many failed attempts. Please try again later.");
      } else {
        failedAlert(text: "Login failed: ${e.message}");
      }
    } catch (e) {
      // Handle unexpected errors
      logger.e(e);
      failedAlert(
          text: "An unexpected error occurred. Please try again later.");
    }
    isUserLoginLoading = false;
    notifyListeners();
  }

  // Handles user sign-up
  Future<void> signUp() async {
    try {
      if (signUpValid()) {
        isUserRegistrationLoading = true;
        notifyListeners();
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text);
        isUserRegistrationLoading = false;
        notifyListeners();
        if (userCredential.user != null) {
          var data = {
            "uid": userCredential.user!.uid,
            "email": emailController.text.trim(),
            "name": nameController.text,
            "photoUrl": GlobalData.defaultAvatar,
            "phone": '',
            "type": "user",
            "createdAt": DateTime.now().millisecondsSinceEpoch,
            "updatedAt": DateTime.now().millisecondsSinceEpoch
          };
          firebaseFirestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .set(data); // Save new user data in Firestore
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
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      if (e.code == 'user-not-found') {
        failedAlert(text: "No account found for this email.");
      } else if (e.code == 'wrong-password') {
        failedAlert(text: "Incorrect password. Please try again.");
      } else {
        failedAlert(text: "Login failed: ${e.message}");
      }
    } catch (e) {
      logger.e(e);
      failedAlert(
          text: "An unexpected error occurred. Please try again later.");
    }
    isUserRegistrationLoading = false;
    notifyListeners();
  }

  // Retrieves the current user's data from Firestore
  getUser() async {
    try {
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        PreferencesHelper.saveUser(userDoc.data());
      }
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  // Handles admin login
  Future<void> adminSignIn() async {
    try {
      if (loginValid()) {
        isAdminLoginLoading = true;
        notifyListeners();
        // Authenticate the user with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text);
        isAdminLoginLoading = false;
        notifyListeners();
        if (userCredential.user != null) {
          // Fetch the user document from Firestore
          DocumentSnapshot userDoc = await firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists && userDoc.get('type') == 'admin') {
            // Save admin data locally
            PreferencesHelper.saveUser(userDoc.data());

            clearFields(); // Clear the input fields
            successAlert(text: "Logged In!");
            // Navigate to Admin Dashboard
            Navigator.pushAndRemoveUntil(
                globalContext(),
                MaterialPageRoute(
                  builder: (context) => const AdminDashboard(),
                ),
                (route) => false);
          } else {
            // Log out the user if not an admin
            failedAlert(text: "You are not authorized to log in as admin.");
            _auth.signOut();
          }
        }
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      if (e.code == 'user-not-found') {
        failedAlert(text: "No account found for this email.");
      } else if (e.code == 'wrong-password') {
        failedAlert(text: "Incorrect password. Please try again.");
      } else if (e.code == 'too-many-requests') {
        failedAlert(text: "Too many failed attempts. Please try again later.");
      } else {
        failedAlert(text: "Login failed: ${e.message}");
      }
    } catch (e) {
      // Handle unexpected errors
      logger.e(e);
      failedAlert(
          text: "An unexpected error occurred. Please try again later.");
    }
    isAdminLoginLoading = false;
    notifyListeners();
  }

  // Handles user logout
  signOut() {
    customCupertinoAlert(
        title: Text(
          "Warning",
          style: TextStyle(color: Theme.of(globalContext()).colorScheme.error),
        ),
        content: "Do you really want to logout?",
        onPressed: () {
          _auth.signOut().then((value) {
            clearFields(); // Clear input fields
            notifyListeners();
            Navigator.pushAndRemoveUntil(
                globalContext(),
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
            Future.delayed(const Duration(milliseconds: 100), () {
              PreferencesHelper.removeUser();
            });
          });
        });
  }
}
