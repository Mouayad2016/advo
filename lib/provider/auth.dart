import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    if (jwt == null) return "";
    return jwt;
  }

  Future logOutUser() async {
    final prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    await prefs.clear();
    if (jwt == null) return "";
    return jwt;
  }

  Future logIn(
    String email,
    String pass,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var data = {
        "email": email,
        "password": pass,
      };
      final response = await post("auth/log", data);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        prefs.setString("token", responseData['token']);
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
