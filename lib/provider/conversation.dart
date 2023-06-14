import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';

class ConversationC {
  final int id;
  final String title;
  final int chatBotId;
  ConversationC(
      {required this.id, required this.title, required this.chatBotId});
}

class ConversationP with ChangeNotifier {
  List<ConversationC> conversations = [];
  List<ConversationC> get allConversation {
    return [...conversations];
  }

  addConversation(ConversationC con) {
    conversations.add(con);
    notifyListeners();
  }

  Future deleteConversation(conId) async {
    try {
      final deleteFormApi = await delete("con/$conId");
      if (deleteFormApi.statusCode == 200) {
        conversations.removeWhere((element) => element.id == conId);
        notifyListeners();
      }
    } catch (e) {}
  }

  Future apiGetConversation(catBotId) async {
    try {
      final List<ConversationC> apiConversations = [];
      final response = await get("con/all/${catBotId}");

      if (response.statusCode == 200) {
        final cleanRes = jsonDecode(response.body);
        for (var i in cleanRes) {
          apiConversations.add(ConversationC(
              id: i["id"], title: i['title'], chatBotId: i['chatBot_id']));
        }

        conversations = apiConversations;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
