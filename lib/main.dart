import 'package:flutter/material.dart';
import 'package:lawyer/provider/auth.dart';
import 'package:lawyer/provider/chatBot.dart';
import 'package:lawyer/provider/conversation.dart';
import 'package:lawyer/provider/messages.dart';
import 'package:lawyer/screens/auth/policy.dart';
import 'package:lawyer/screens/auth/signup.dart';
import 'package:lawyer/screens/chatBot.dart';
import 'package:lawyer/screens/chatScreen.dart';
import 'package:lawyer/screens/hem.dart';
import 'package:lawyer/screens/auth/login.dart';
import 'package:lawyer/screens/profile.dart';

import 'package:provider/provider.dart';
import './layout/mobile.dart';

void main() {
  runApp(const MyApp());
}

MaterialColor myColor = const MaterialColor(0xFF3B6B9D, {
  50: Color(0xFFE3EAF1),
  100: Color(0xFFBBC8DB),
  200: Color(0xFF93A6C5),
  300: Color(0xFF6B84AF),
  400: Color(0xFF43629A),
  500: Color(0xFF3B6B9D), // Primary color
  600: Color(0xFF324F81),
  700: Color(0xFF2A4364),
  800: Color(0xFF213648),
  900: Color(0xFF19242C),
});

MaterialColor mySecound = MaterialColor(0xFFD5D1A4, {
  50: Color(0xFFD5D1A4),
  100: Color(0xFFD5D1A4),
  200: Color(0xFFD5D1A4),
  300: Color(0xFFD5D1A4),
  400: Color(0xFFD5D1A4),
  500: Color(0xFFD5D1A4), // Primary color
  600: Color(0xFFD5D1A4),
  700: Color(0xFFD5D1A4),
  800: Color(0xFFD5D1A4),
  900: Color(0xFFD5D1A4)
});

Color backgroundColor = const Color(0xFFEAF5FB);
Color onSecound = const Color(0xFF1F2C47);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ColorScheme lightcolorScheme = ColorScheme(
      primary: myColor,
      onPrimary: Colors.white,
      secondary: mySecound,
      onSecondary: Colors.white,
      background: backgroundColor,
      shadow: Colors.grey.withOpacity(0.3),
      primaryContainer: mySecound,
      onPrimaryContainer: Colors.black,
      onSurface: Colors.grey[600]!,
      surface: Colors.grey[100]!,
      onBackground: Colors.grey[600]!,
      onError: Colors.white,
      error: Colors.white,
      brightness: Brightness.light,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ChatBotP()),
        ChangeNotifierProvider(create: (ctx) => ConversationP()),
        ChangeNotifierProvider(create: (ctx) => MessageP()),
        ChangeNotifierProvider(create: (ctx) => AuthP()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            bottomAppBarTheme: const BottomAppBarTheme(
                // color: Colors.black,
                ),
            appBarTheme: AppBarTheme(
              backgroundColor: mySecound,
              elevation: 4,
              titleTextStyle: TextStyle(
                // color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Roboto',
              ),
              iconTheme: IconThemeData(
                color: Colors
                    .grey[600], // Set the color of the icons in the app bar
              ),
            ),
            scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(16),
                thickness: MaterialStateProperty.all(5),
                thumbColor: MaterialStateProperty.all(Colors.grey[600]!)),
            colorScheme: lightcolorScheme,
            inputDecorationTheme: InputDecorationTheme(
                errorStyle: const TextStyle(
                  color: Colors.red, // set the color of the error text
                  fontSize: 12, // set the font size of the error text
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                prefixIconColor: Colors.grey[600],
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                suffixIconColor: myColor),
            primarySwatch: mySecound,
            scaffoldBackgroundColor: backgroundColor),
        home: const MyHomePage(),
        routes: {
          Hem.routName: (ctx) => const Hem(),
          ChatBot.routName: (ctx) => const ChatBot(),
          Chat.routName: (ctx) => const Chat(),
          Profile.routName: (ctx) => const Profile(),
          Signup.routName: (ctx) => const Signup(),
          Policy.routName: (ctx) => const Policy(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthP>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: null,
          // future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            return FutureBuilder(
              future: auth.jwtOrEmpty,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.data != "") {
                  return const MobileScreenLayout();
                } else {
                  return const LoginPage();
                }
              },
            );
          }),
    );
  }
}
