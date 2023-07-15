import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PolicyC {
  final int id;
  final String text;
  PolicyC({required this.id, required this.text});
}

class AuthP with ChangeNotifier {
  Future signUp(String fname, String lName, String email, String pass,
      bool isPolicyAccepted, int policy_id) async {
    try {
      var data = {
        "email": email,
        "password": pass,
        "first_name": fname,
        "last_name": lName,
        "policy_accepted": isPolicyAccepted,
        "policy_id": policy_id
      };
      await post("auth/re", data);
    } catch (error) {
      rethrow;
    }
  }

  PolicyC policy = PolicyC(id: 0, text: "");
  PolicyC get myPolicy {
    return policy;
  }

  Future getPolicy() async {
    try {
      final response = await get("policy/policies/latest");
      List cleanRes = json.decode(response.body);
      if (cleanRes.isNotEmpty) {
        policy = PolicyC(id: cleanRes[0]["id"], text: cleanRes[0]["text"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> get jwtOrEmpty async {
    // final prefs = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      rethrow;
    }
  }
}
