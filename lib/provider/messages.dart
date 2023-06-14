import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawyer/helper/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  disconnect() {
    final socket = doSocketConnection();
    socket.disconnect();
  }

  doConnect() {
    final socket = doSocketConnection();
    if (socket.disconnected) {
      socket.connect();
    }
    socket.off("response");
    socket.on("response", (data) {
      var ressolt = messages[0].text + data;
      messages[0].text = ressolt;
      notifyListeners();
    });
  }

  Future doMessages(text, conversationId, chatbotId) async {
    try {
      isGenerating = true;
      notifyListeners();
      var data = {
        "user_id": 1,
        "conversation_id": conversationId,
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

  IO.Socket doSocketConnection() {
    final IO.Socket socket = IO.io(
        'http://192.168.1.49:8080',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"userid": 1})
            .disableAutoConnect()
            // .setQuery({"token": jwt})
            // .setAuth({"token": jwt})
            .build());
    return socket;
  }
}
