import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawyer/provider/chatBot.dart';
import 'package:lawyer/provider/conversation.dart';
import 'package:lawyer/screens/chatScreen.dart';
import 'package:lawyer/widgets/futureBuilder.dart';
import 'package:lawyer/widgets/noData.dart';
import 'package:provider/provider.dart';

class ChatScreenroutArgs {
  final int? chatbotId;
  int? comversationId;
  String title;
  final String chatBotIdentifier;
  final bool isNewConversation;
  ChatScreenroutArgs(
      {required this.chatbotId,
      required this.comversationId,
      required this.title,
      required this.chatBotIdentifier,
      required this.isNewConversation});
}

class ChatBot extends StatefulWidget {
  static const routName = "/chatBot";

  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool _isLoadingFirst = false;

  @override
  void initState() {
    _isLoadingFirst = true;
    // TODO: implement initState
    super.initState();
  }

  Future getData() async {
    if (_isLoadingFirst) {
      ChatBotC chatBot = ModalRoute.of(context)!.settings.arguments as ChatBotC;
      final provider = Provider.of<ConversationP>(context, listen: false);
      await provider.apiGetConversation(chatBot.id);
      _isLoadingFirst = false;
    }
  }

  Future onRefresh() async {
    ChatBotC chatBot = ModalRoute.of(context)!.settings.arguments as ChatBotC;
    final provider = Provider.of<ConversationP>(context, listen: false);
    await provider.apiGetConversation(chatBot.id);
  }

  final myProvider = ConversationP();
  final ScrollController myScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ChatBotC chatBot = ModalRoute.of(context)!.settings.arguments as ChatBotC;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(FontAwesomeIcons.xmark),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          chatBot.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Consumer<ConversationP>(
            builder: (context, myType, child) {
              return FutureBuilderWidget(
                func: () async {
                  await myType.apiGetConversation(chatBot.id);
                },
                future: getData(),
                onLowad: onLoad(),
                child: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    await onRefresh();
                  },
                  child: myType.allConversation.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          children: [
                            EmptyDataWidget(
                              buttonText: "Skapa en här",
                              buttonFunc: () {
                                Navigator.of(context).pushNamed(Chat.routName,
                                    arguments: ChatScreenroutArgs(
                                        title: "",
                                        chatbotId: chatBot.id,
                                        chatBotIdentifier: chatBot.chatbotid,
                                        comversationId: null,
                                        isNewConversation: true));
                              },
                              message:
                                  "Du har inga konversation med ${chatBot.title} chatbot skapa en !",
                            )
                          ],
                        )
                      : Scrollbar(
                          radius: Radius.circular(16),
                          controller: myScrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          Chat.routName,
                                          arguments: ChatScreenroutArgs(
                                            title: myType
                                                .allConversation[index].title,
                                            chatbotId: myType
                                                .allConversation[index]
                                                .chatBotId,
                                            chatBotIdentifier:
                                                chatBot.chatbotid,
                                            comversationId: myType
                                                .allConversation[index].id,
                                            isNewConversation: false,
                                          ),
                                        );
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 1.0,
                                        ),
                                      ),
                                      leading: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[300]!,
                                              blurRadius: 3.0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            FontAwesomeIcons.paperPlane,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              myType
                                                  .allConversation[index].title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final provider =
                                                  Provider.of<ConversationP>(
                                                      context,
                                                      listen: false);
                                              provider.deleteConversation(myType
                                                  .allConversation[index].id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        FontAwesomeIcons.angleRight,
                                        size: 18,
                                      ));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemCount: myType.allConversation.length),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Chat.routName,
              arguments: ChatScreenroutArgs(
                  chatBotIdentifier: chatBot.chatbotid,
                  title: "",
                  chatbotId: chatBot.id,
                  comversationId: null,
                  isNewConversation: true));
          // Add your onPressed code here!
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: const Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
          // color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const SquareNotchedShape(notchRadius: 16),
        child: Container(
          height: 40.0,
        ),
      ),
    );
  }
}

class SquareNotchedShape extends NotchedShape {
  final double notchRadius;

  const SquareNotchedShape({this.notchRadius = 10.0});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    final notchRadius = this.notchRadius;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: guest.center,
            width: guest.width,
            height: guest.height,
          ),
          Radius.circular(notchRadius),
        ),
      );

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(host),
      path,
    );
  }
}

Widget onLoad() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              FontAwesomeIcons.angleRight,
              color: Colors.white,
            )),
        const SizedBox(
          height: 8,
        ),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              FontAwesomeIcons.angleRight,
              color: Colors.white,
            )),
        const SizedBox(
          height: 8,
        ),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              FontAwesomeIcons.angleRight,
              color: Colors.white,
            )),
      ],
    ),
  );
}
