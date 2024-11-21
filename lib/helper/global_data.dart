import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selectable/helper/enum.dart';

import '../main.dart';

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

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

getStatusColor(String status) {
  if(status == BookingStatus.pending.name){
    return Colors.blue;
  }
  if(status == BookingStatus.confirmed.name){
    return Colors.orangeAccent;
  }
  if(status == BookingStatus.completed.name){
    return Colors.green;
  }
  if(status == BookingStatus.cancelled.name){
    return Colors.pink;
  }
  if(status == BookingStatus.declined.name){
    return Colors.redAccent;
  }
  return Colors.grey;
}


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


checkPermission(Permission permission) async {
  try {
    logger.e("Status: ${permission.isGranted}");
    var status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      if (!status.isGranted) {
        openAppSettings();
      }
    }
    status = await permission.status;
    logger.e("Status: ${status.isGranted}");
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Permissions denied permanently, take the user to app settings
      openAppSettings();
    }
    return false;
  } catch (e) {
    logger.e(e);
    return false;
  }
}

Future<File?> captureImage(
    ImageSource captureMode, BuildContext context) async {
  try {
    bool status = await checkPermission(Permission.storage);
    File? file;
    if (status) {
      ImagePicker picker = ImagePicker();

      XFile? pickedImage = await (picker.pickImage(source: captureMode));
      if (pickedImage != null) {
        file = File(pickedImage.path);
      }
    }
    return file;
  } catch (e) {
    logger.e(e);
    return null;
  }
}
