
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PreferencesHelper {
  static late SharedPreferences preferences;
  static late var box;

  static String tokenKey = "token";
  static String userKey = "user";
  static String userCourtKey = "user-court";
  static String settingsKey = "settings";
  static String boardingKey = "boarding";

  static bool getBoardingStatus() {
    if (preferences.containsKey(boardingKey)) {
      return preferences.getBool(boardingKey)!;
    } else {
      return false;
    }
  }

  static saveBoardingStatus(bool status) {
    preferences.setBool(boardingKey, status);
  }

  static removeBoardingStatus() {
    preferences.remove(boardingKey);
  }

  // User
  static dynamic getUser() {
    if (preferences.containsKey(userKey)) {
      logger.d(("User ${preferences.getString(userKey)}"));
      return jsonDecode(preferences.getString(userKey)!);
    } else {
      return null;
    }
  }

  static saveUser(user) {
    preferences.setString(userKey, jsonEncode(user));
  }


  static removeUser() {
    preferences.remove(userKey);
  }

  /// String
  static String getStringByKey(String key) {
    if (preferences.containsKey(key)) {
      return preferences.getString(key) ??  "";
    } else {
      return "";
    }
  }

  static saveString(String key, String value) {
    preferences.setString(key, value);
  }

  static removeKey(String key) {
    preferences.remove(key);
  }

}
