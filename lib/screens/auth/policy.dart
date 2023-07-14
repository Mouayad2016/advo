import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lawyer/provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Policy extends StatelessWidget {
  static const routName = "/policy";
  const Policy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void launch(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    void _onOpen(LinkableElement link) {
      launch(Uri.parse(link.url));
    }

    // Controller for the ScrollBar and ListView.
    final ScrollController scrollController = ScrollController();

    // Get the text passed via ModalRoute.
    final String policyText =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      // AppBar with a title.
      appBar: AppBar(
        title: const Text(
          "Sekretesspolicy",
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: scrollController, // set the controller
          child: ListView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),

            controller: scrollController, // set the controller
            children: [
              SizedBox(
                height: 16,
              ),
              // Padding widget for the SelectableText.
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: SelectableText(
                  "Väkomen till vårt policy",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Linkify(
                  onOpen: _onOpen,
                  text: policyText,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onBackground),
                  linkStyle: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
