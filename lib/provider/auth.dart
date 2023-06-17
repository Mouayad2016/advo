import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';
import 'package:lawyer/models/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthP with ChangeNotifier {
  Future signUp(
    String fname,
    String lName,
    String email,
    String pass,
  ) async {
    try {
      var data = {
        "email": email,
        "password": pass,
        "first_name": fname,
        "last_name": lName
      };
      await post("auth/re", data);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> get jwtOrEmpty async {
    // final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    String? jwt = await storage.read(key: "token");
    if (jwt == null) return "";
    return jwt;
  }

  Future logOutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    String? jwt = await storage.read(key: "token");
    // var jwt = prefs.getString("token");
    await storage.deleteAll();
    await prefs.clear();
    // await prefs.remove('fName');
    // await prefs.remove('lName');
    // await prefs.remove('email');
    if (jwt == null) return "";
    return jwt;
  }

  Future logIn(
    String email,
    String pass,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final storage = new FlutterSecureStorage();
      var data = {
        "email": email,
        "password": pass,
      };
      // await prefs.remove('token');
      // await prefs.remove('fName');
      // await prefs.remove('lName');
      // await prefs.remove('email');
      final response = await post("auth/log", data);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // prefs.setString("token", responseData['token']);
        await storage.write(key: "token", value: responseData['token']);
        prefs.setString("fName", responseData['user']['first_name']);
        prefs.setString("lName", responseData['user']['last_name']);
        prefs.setString("email", responseData['user']['email']);
      }
      return;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
