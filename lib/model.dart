import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? city;
  String? state;
  String? pincode;
  String? gender;
  final Uint8List? profilePicture;

  static const String IMG_KEY = 'profilePicture';

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.city,
    this.state,
    this.pincode,
    this.gender,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobile': mobile,
        'city': city,
        'state': state,
        'pincode': pincode,
        'gender': gender,
        'profilePicture': base64String(profilePicture!),
      };

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobile: json['mobile'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      gender: json['gender'],
      profilePicture: base64Decode(json['profilePicture']),
    );
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(toJson()));
  }

  static Future<User?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return User.fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> deleteUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove(IMG_KEY);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}
