import 'dart:convert';

import 'package:practical_test2/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final String key = 'users';

  static Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(key) ?? '[]';
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static Future<void> addUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(key) ?? '[]';
    List<dynamic> jsonList = jsonDecode(jsonString);
    jsonList.add(user.toJson());
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<void> updateUser(int index, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(key) ?? '[]';
    List<dynamic> jsonList = jsonDecode(jsonString);
    jsonList[index] = user.toJson();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<void> deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(key) ?? '[]';
    List<dynamic> jsonList = jsonDecode(jsonString);
    jsonList.removeAt(index);
    await prefs.setString(key, jsonEncode(jsonList));
  }
}
