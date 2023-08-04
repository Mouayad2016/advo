import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lawyer/models/exception.dart';
import 'package:lawyer/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> get(urll) async {
  try {
    final url = Uri.parse('$myUrl/$urll');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");

    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};
    if (jwt != null) {
      tokenData = {"Content-Type": "application/json", "token": jwt};
    }
    final response = await http
        .get(
      url,
      headers: tokenData,
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw ErrorException("fel inträffat");
    });
    if (response.statusCode == 400) {
      final cleanResposne = json.decode(response.body);
      throw ErrorException(cleanResposne['error']);
    }
    return response;
  } catch (error) {
    rethrow;
  }
}

Future<http.Response> post(urll, data) async {
  try {
    final url = Uri.parse('$myUrl/$urll');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");

    ;
    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};
    if (jwt != null) {
      tokenData = {"Content-Type": "application/json", "token": jwt};
    }
    final response = await http
        .post(url, headers: tokenData, body: json.encode(data))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw ErrorException("fel inträffat");
    });
    if (response.statusCode != 200) {
      final cleanResposne = json.decode(response.body);
      if (response.statusCode == 401) {
        throw ConflictException("E-post eller lösenord är fel!");
      }
      if (response.statusCode == 402) {
        throw ConflictException("E-post är redan använd!");
      }
      if (response.statusCode == 403) {
        throw ConflictException(
            "För att kunna använda våra tjänster måste du godkänna vårt privacy policy. Vänligen läs och godkänn vårt policy");
      }
      throw ErrorException(cleanResposne['error']);
    }
    return response;
  } catch (error) {
    rethrow;
  }
}

Future<http.Response> postChatMessage(urll, data) async {
  try {
    final url = Uri.parse('$myUrl/$urll');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");

    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};
    if (jwt != null) {
      tokenData = {"Content-Type": "application/json", "token": jwt};
    }
    final response = await http
        .post(url, headers: tokenData, body: json.encode(data))
        .timeout(const Duration(minutes: 2), onTimeout: () {
      throw ErrorException("fel inträffat");
    });
    if (response.statusCode != 200) {
      final cleanResposne = json.decode(response.body);

      throw ErrorException(cleanResposne['error']);
    }
    return response;
  } catch (error) {
    rethrow;
  }
}

Future<http.Response> delete(urll) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");
    final url = Uri.parse('$myUrl/$urll');
    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};
    if (jwt != null) {
      tokenData = {"Content-Type": "application/json", "token": jwt};
    }
    final response = await http
        .delete(url, headers: tokenData)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw ErrorException("fel inträffat");
    });
    if (response.statusCode != 200) {
      final cleanResposne = json.decode(response.body);
      throw ErrorException(cleanResposne['error']);
    }
    return response;
  } catch (error) {
    rethrow;
  }
}
