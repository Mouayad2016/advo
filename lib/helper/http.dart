import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lawyer/models/exception.dart';
import 'package:lawyer/url.dart';

Future<http.Response> get(urll) async {
  try {
    final url = Uri.parse('$myUrl/$urll');
    Map<String, String> tokenData = {"Content-Type": "application/json"};
    final response = await http
        .get(
      url,
      headers: tokenData,
    )
        .timeout(const Duration(seconds: 10), onTimeout: () {
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
    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};

    final response = await http
        .post(url, headers: tokenData, body: json.encode(data))
        .timeout(const Duration(seconds: 10), onTimeout: () {
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
      throw ErrorException(cleanResposne['error']);
    }
    return response;
  } catch (error) {
    rethrow;
  }
}

Future<http.Response> delete(urll) async {
  try {
    final url = Uri.parse('$myUrl/$urll');
    Map<String, String> tokenData = {};
    tokenData = {"Content-Type": "application/json"};

    final response = await http
        .delete(url, headers: tokenData)
        .timeout(const Duration(seconds: 10), onTimeout: () {
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