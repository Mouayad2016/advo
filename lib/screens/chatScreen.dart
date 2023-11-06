import 'package:flutter/material.dart';
import 'package:lawyer/main.dart';
import 'package:lawyer/provider/conversation.dart';
import 'package:lawyer/provider/messages.dart';
import 'package:lawyer/screens/chatBot.dart';
import 'package:lawyer/widgets/futureBuilder.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Chat extends StatefulWidget {
  static const routName = "/chat";
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

// !
class _ChatState extends State<Chat> {
  final myProvider = MessageP();

  @override
  void initState() {
    myProvider.doConnect();
    myProvider.isScreenOppen = true;
    // TODO: implement initState
    super.initState();
  }

  Future getData() async {
    final ChatScreenroutArgs conversation =
        ModalRoute.of(context)!.settings.arguments as ChatScreenroutArgs;
    if (!conversation.isNewConversation) {
      await myProvider.getConversationById(conversation.comversationId);
    } else {
      return;
    }
  }

  final ScrollController myScrollController = ScrollController();

  final TextEditingController textFildContrioller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ChatScreenroutArgs conversation =
        ModalRoute.of(context)!.settings.arguments as ChatScreenroutArgs;
    return WillPopScope(
        onWillPop: () async {
          myProvider.disconnect();
          myProvider.isScreenOppen = false;
          return true;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).nextFocus();
          },
          child: ChangeNotifierProvider(
              create: (_) => myProvider,
              child: Scaffold(
                  appBar: AppBar(
                    leading: InkWell(
                        onTap: () {
                          myProvider.isScreenOppen = false;
                          myProvider.disconnect();
                          Navigator.of(context).pop();
                        },
                        child: const Icon(FontAwesomeIcons.xmark)),
                    title: Text(
                      conversation.title == "" ? "?" : conversation.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilderWidget(
                              func: () async {
                                await getData();
                              },
                              future: getData(),
                              child: Consumer<MessageP>(
                                builder: (context, myType, child) {
                                  return Scrollbar(
                                    controller: myScrollController,
                                    child: ListView.builder(
                                        controller: myScrollController,
                                        reverse: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                                parent:
                                                    BouncingScrollPhysics()),
                                        itemCount: myType.allmessages.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ChatMessage(
                                            message:
                                                myType.allmessages[index].text,
                                            type:
                                                myType.allmessages[index].type,
                                          );
                                        }),
                                  );
                                },
                              )),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            // height: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Consumer<MessageP>(
                                builder: (context, myType, child) {
                                  return TextField(
                                    controller: textFildContrioller,
                                    enabled: true,
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(FontAwesomeIcons.question),
                                        filled: true,
                                        suffixIcon: InkWell(
                                            onTap: () async {
                                              if (!myType.isGenerating) {
                                                if (textFildContrioller
                                                    .text.isEmpty) {
                                                  return;
                                                }
                                                final textBody =
                                                    textFildContrioller
                                                        .value.text
                                                        .trim();
                                                textFildContrioller.clear();
                                                ChatScreenroutArgs
                                                    conversation =
                                                    ModalRoute.of(context)!
                                                            .settings
                                                            .arguments
                                                        as ChatScreenroutArgs;
                                                myProvider
                                                    .addSendMessage(textBody);
                                                if (conversation
                                                        .comversationId ==
                                                    null) {
                                                  final res = await myProvider
                                                      .doMessages(
                                                          textBody,
                                                          conversation
                                                              .comversationId,
                                                          conversation
                                                              .chatbotId,
                                                          conversation
                                                              .chatBotIdentifier);
                                                  conversation.comversationId =
                                                      res['receivedMessage']
                                                          ['conversation_id'];
                                                  setState(() {
                                                    conversation.title =
                                                        textBody;
                                                  });

                                                  Provider.of<ConversationP>(
                                                          context,
                                                          listen: false)
                                                      .addConversation(ConversationC(
                                                          id: conversation
                                                              .comversationId!,
                                                          title: textBody,
                                                          chatBotId:
                                                              conversation
                                                                  .chatbotId!));
                                                } else {
                                                  myProvider.doMessages(
                                                      textBody,
                                                      conversation
                                                          .comversationId,
                                                      conversation.chatbotId,
                                                      conversation
                                                          .chatBotIdentifier);
                                                  textFildContrioller.clear();
                                                }
                                              }
                                              return;
                                            },
                                            child: myType.isGenerating
                                                ? Container(
                                                    width: 30,
                                                    child: SpinKitSquareCircle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 18.0,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.send,
                                                  ))),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  ))),
        ));
  }
}

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final String message;
  final MessageType type;

  ChatMessage({super.key, required this.message, required this.type});
  Color backgroundColor = const Color.fromARGB(255, 231, 247, 255);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: type == MessageType.Received ? myColor[300] : myColor[200],
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // : MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 8),
          Container(
            child: type == MessageType.Received
                ? const Icon(
                    FontAwesomeIcons.balanceScale,
                    color: Colors.white,
                    size: 18,
                  )
                : const Icon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.white,
                    size: 18,
                  ),
          ),
          // : Container
          const SizedBox(width: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: SelectableText(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
