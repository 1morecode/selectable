import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

final Size size =
    MediaQuery.of(globalContext()).size;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey();

BuildContext globalContext() {
  return navigatorKey.currentState!.context;
}

var emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
var phoneRegExp = RegExp(
    r'^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[56789]\d{9}|(\d[ -]?){10}\d$');

// Minimum eight characters, at least one letter and one number:
var password1RegExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

// Minimum eight characters, at least one letter, one number and one special character:
var password2RegExp =
RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$");

// Minimum eight characters, at least one uppercase letter, one lowercase letter and one number:
var password3RegExp = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

// Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
var password4RegExp = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");


class GlobalData {
  GlobalData._();

  static String defaultAvatar =
      'https://firebasestorage.googleapis.com/v0/b/xtranger-1mc.appspot.com/o/default.jpeg?alt=media&token=d0eb0d47-c725-453e-b1bc-ce1ad642e634';

  static final format = DateFormat("MMM d, yyyy");
  static final normal = DateFormat("MMM d, yyyy h:mm a");

  static String longDateFormate(DateTime date) {
    String res = DateFormat("dd/MM/yyyy").format(date);
    return res;
  }

  static String shortDateFormate(DateTime date) {
    String res = DateFormat("dd-MM-yyyy").format(date);
    return res;
  }

  static String shortTimeFormate(DateTime date) {
    String res = DateFormat("hh:mm").format(date);
    return res;
  }

  static DateTime convertToDateTime(String date) {
    DateTime res = DateTime.parse(date);
    return res;
  }
}
