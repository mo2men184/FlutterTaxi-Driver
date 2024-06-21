// ignore_for_file: file_names

import 'dart:convert';

import 'package:rugbydriver/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";
  static const languageCodeKey = "languageCodeKey";
  static const isLogin = "isLogin";
  static const user = "userData";
  static const userId = "userId";
  static const accesstoken = "accesstoken";
  static const admincommission = "admincommission";
  static const documentVerified = 'documentVerified';
  static const admincommissiontype = "admincommissiontype";
  static const paymentSetting = "paymentSetting";
  static const walletBalance = "walletBalance";

  static late SharedPreferences pref;

  static setUserData(UserModel userModel) async {
    await pref.setString(user, jsonEncode(userModel));
  }

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  static bool getBoolean(String key) {
    return pref.getBool(key) ?? false;
  }

  static Future<void> setBoolean(String key, bool value) async {
    await pref.setBool(key, value);
  }

  static String getString(String key) {
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    await pref.setString(key, value);
  }

  static Future<void> clearSharPreference() async {
    await pref.clear();
  }

  static Future<void> clearKeyData(String key) async {
    await pref.remove(key);
  }

  static int getInt(String key) {
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setInt(String key, int value) async {
    await pref.setInt(key, value);
  }
}
