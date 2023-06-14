import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';

class ChatBotC {
  final int id;
  final String title;
  final String chatbotid;
  final bool isfree;
  ChatBotC(
      {required this.id,
      required this.title,
      required this.isfree,
      required this.chatbotid});
}

class ChatBotP with ChangeNotifier {
  List<ChatBotC> chatBots = [];

  get allchatBots {
    return [...chatBots];
  }

  Future apiGetChatBots() async {
    try {
      List<ChatBotC> chatBots1 = [];
      print("call");
      final response = await get("bot");
      if (response.statusCode == 200) {
        final cleanRes = jsonDecode(response.body);
        for (var i in cleanRes) {
          chatBots1.add(ChatBotC(
              id: i['id'],
              title: i['title'],
              isfree: i['isfree'],
              chatbotid: i['chatbotid']));
        }
        chatBots = chatBots1;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
