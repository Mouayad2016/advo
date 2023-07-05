import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawyer/screens/profile.dart';
import '../screens/hem.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int page = 0;
  void namvigationTap(int pagee) {
    page = pagee;

    pageController.jumpToPage(page);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Profile.routName);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 32),
                child: Icon(
                  FontAwesomeIcons.solidUser,
                ),
              ),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Advo",
              )
            ],
          ),
        ),
        body: const Hem());
  }
}
