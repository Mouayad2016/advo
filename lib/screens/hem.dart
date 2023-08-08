import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawyer/provider/chatBot.dart';
import 'package:lawyer/screens/chatBot.dart';
import 'package:lawyer/widgets/futureBuilder.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class Hem extends StatefulWidget {
  static const routName = "/hem";

  const Hem({super.key});

  @override
  State<Hem> createState() => _HemState();
}

class _HemState extends State<Hem> {
  Future getData() async {
    await Provider.of<ChatBotP>(context, listen: false).apiGetChatBots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget(
        func: () {
          getData();
        },
        future: getData(),
        onLowad: Container(),
        child: RefreshIndicator.adaptive(
            child: HomeGrid(),
            onRefresh: () async {
              await getData();
            }));
  }
}

class HomeGrid extends StatelessWidget {
  const HomeGrid({
    super.key,
  });

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =
        screenWidth ~/ 180; // 200 is the desired width of each grid item.
    return crossAxisCount;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController myScrollController = ScrollController();

    return Consumer<ChatBotP>(
      builder: (context, myType, child) {
        return Scrollbar(
          controller: myScrollController,
          radius: Radius.circular(16),
          child: GridView.builder(
            controller: myScrollController,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: myType.chatBots.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: calculateCrossAxisCount(context)),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ChatBot.routName,
                        arguments: ChatBotC(
                            id: myType.chatBots[index].id,
                            title: myType.chatBots[index].title,
                            isfree: myType.chatBots[index].isfree,
                            chatbotid: myType.chatBots[index].chatbotid));
                  },
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesomeIcons.microchip,
                                  color: Colors.grey[600]!,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 32),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade600,
                                  thickness: 1,
                                ),
                              ),
                              Icon(
                                size: 18,
                                color: Colors.grey.shade600,
                                FontAwesomeIcons.angleRight,
                              )
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              myType.chatBots[index].title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
