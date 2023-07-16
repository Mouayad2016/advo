import 'package:flutter/material.dart';
import 'package:lawyer/layout/mobile.dart';
import 'package:lawyer/models/exception.dart';
import 'package:lawyer/provider/auth.dart';
import 'package:lawyer/screens/auth/helper.dart';
import 'package:lawyer/screens/auth/signup.dart';
import 'package:lawyer/widgets/dialog.dart';
import 'package:lawyer/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routName = "/login";

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future logIn() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text;
    String pass = _passwordController.text;
    final valid = _formKey.currentState!.validate();
    print("herer");
    if (valid) {
      try {
        await Provider.of<AuthP>(context, listen: false).logIn(email, pass);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        );
      } on ConflictException {
        showMyErroDialog(context, "E-post eller lösenord är fel !", () {
          Navigator.of(context).pop();
        });
      } catch (e) {
        showMyErroDialog(context, "Fel inträffade vänligen försök senare", () {
          Navigator.of(context).pop();
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
          height: 70,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamed(Signup.routName);
                  },
                  child: const Text(
                    'Registrera dig',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Text(
                        'Logga in',
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange din e-post adress';
                            }
                            if (!isValidEmail(value)) {
                              return 'Vänligen ange en korrekt e-postadress ex ex@e.com';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'E-post',
                            prefixIcon: const Icon(
                              Icons.mail,
                            ),
                            labelStyle: const TextStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange ett lösenord';
                            }
                            if (value.length < 6) {
                              return 'Ditt lösenord måste vara minst 6 tecken långt';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Lösenord',
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            labelStyle: const TextStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 300,
                        child: _isLoading
                            ? shimmerWidget(ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Skicka in',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                            : ElevatedButton(
                                onPressed: () async {
                                  await logIn(); // TODO: Handle signup
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Skicka in',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
