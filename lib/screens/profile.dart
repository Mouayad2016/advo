import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lawyer/provider/auth.dart';
import 'package:lawyer/screens/auth/login.dart';
import 'package:lawyer/widgets/futureBuilder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  static const routName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? fName;
  bool isLoadingFirst = false;
  @override
  void initState() {
    isLoadingFirst = true;
    // TODO: implement initState
    super.initState();
  }

  Future getName() async {
    final prefs = await SharedPreferences.getInstance();
    fName = prefs.getString("fName");
    setState(() {});
    isLoadingFirst = false;
  }

  final ScrollController myScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () async {
            await Provider.of<AuthP>(context, listen: false).logOutUser();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/", (route) => false);
            Navigator.of(context).pushNamed(LoginPage.routName);
          },
          child: const Text('Logga ut'),
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(FontAwesomeIcons.xmark)),
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Scrollbar(
          controller: myScrollController,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            children: [
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(children: [
                  FutureBuilderWidget(
                      func: () async {
                        await getName();
                      },
                      future: isLoadingFirst ? getName() : null,
                      child: Text(
                        "Hej! ${fName == null ? "" : fName!}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.wallet),
                    title: const Text('Din plan'),
                    subtitle: const Text('Gratis version'),
                    trailing: TextButton(
                      onPressed: () {
                        // TODO: Handle upgrade button press
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.green),
                      child: const Text('Uppgradera'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(children: [
                  const Text('Följa oss',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SocialMediaButton(
                      icon: FontAwesomeIcons.discord,
                      label: 'Gå med i vår Discord',
                      onPressed: () {/* TODO */}),
                  SocialMediaButton(
                      icon: FontAwesomeIcons.facebook,
                      label: 'Gilla oss på Facebook',
                      onPressed: () {/* TODO */}),
                  SocialMediaButton(
                      icon: FontAwesomeIcons.linkedin,
                      label: 'Följ oss på LinkedIn',
                      onPressed: () {/* TODO */}),
                  const SizedBox(height: 20),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SocialMediaButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onPressed,
    );
  }
}
