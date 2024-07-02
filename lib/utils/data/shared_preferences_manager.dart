import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> getInstance() async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }
}

Future<void> saveSessionId(String sessionId) async {
  SharedPreferences prefs = await SharedPreferencesManager.getInstance();
  await prefs.setString('sessionId', sessionId);
}

Future<String?> getSessionId() async {
  SharedPreferences prefs = await SharedPreferencesManager.getInstance();
  return prefs.getString('sessionId');
}

Future<void> saveSessionRole(String role) async {
  SharedPreferences prefs = await SharedPreferencesManager.getInstance();
  debugPrint('saveSessionRole: $role');
  await prefs.setString('role', role);
}

Future<String?> getSessionRole() async {
  SharedPreferences prefs = await SharedPreferencesManager.getInstance();
  return prefs.getString('role');
}