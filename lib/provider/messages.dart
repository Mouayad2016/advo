import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';
import 'package:lawyer/url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

enum MessageType { Sent, Received }

class Message {
  int? id;
  String text;
  final MessageType type;

  Message({required this.id, required this.text, required this.type});
}

class MessageP with ChangeNotifier {
  bool isGenerating = false;
  List<Message> messages = [];

  get allmessages {
    return [...messages];
  }

  Future getConversationById(conId) async {
    try {
      final List<Message> messages1 = [];
      final response = await get("con/$conId");
      if (response.statusCode == 200) {
        final cleanRes = jsonDecode(response.body);

        for (var i in cleanRes['chats']) {
          messages1.add(Message(
              id: i["id"],
              text: i['text'],
              type: i['isFromUser'] == true
                  ? MessageType.Sent
                  : MessageType.Received));
        }
        messages = messages1;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  addSendMessage(text) {
    messages.insert(0, Message(id: null, text: text, type: MessageType.Sent));
    messages.insert(0, Message(id: null, text: "", type: MessageType.Received));

    notifyListeners();
  }

  disconnect() async {
    final jwt = await getToken();
    final socket = doSocketConnection(jwt);
    socket.disconnect();
  }

  doConnect() async {
    try {
      final jwt = await getToken();
      final socket = doSocketConnection(jwt);
      if (socket.disconnected) {
        socket.connect();
      }
      socket.off("response");
      socket.on("response", (data) {
        print("res");
        var ressolt = messages[0].text + data;
        messages[0].text = ressolt;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  Future doMessages(text, conversationId, chatbotId, chatBotIdentifier) async {
    try {
      isGenerating = true;
      notifyListeners();
      var data = {
        "conversation_id": conversationId,
        "chatBotIdentifier": chatBotIdentifier,
        "text": text,
        "chatBot_id": chatbotId
      };
      final response = await post("me", data);
      final cleanres = json.decode(response.body);
      isGenerating = false;
      notifyListeners();
      return cleanres;
    } catch (e) {
      rethrow;
    }
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString("token");
    return jwt;
  }

  IO.Socket doSocketConnection(jwt) {
    final IO.Socket socket = IO.io(
      myUrl,
        // 'http://192.168.1.49:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"token": jwt})
            .disableAutoConnect()
            // .setQuery({"token": jwt})
            // .setAuth({"token": jwt})
            .build());
    return socket;
  }
}
