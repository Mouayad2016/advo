import 'package:flutter/material.dart';
import 'package:lawyer/models/exception.dart';
import 'package:lawyer/provider/auth.dart';
import 'package:lawyer/screens/auth/helper.dart';
import 'package:lawyer/screens/auth/policy.dart';
import 'package:lawyer/widgets/dialog.dart';
import 'package:lawyer/widgets/futureBuilder.dart';

import 'package:lawyer/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  static const routName = "/signUp";

  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPolicyChecked = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  bool _isLoadingFirst = false;
  bool? _triggerPoilcyError = null;
  @override
  void initState() {
    _isLoadingFirst = true;
    // TODO: implement initState
    super.initState();
  }

  getPolicy() async {
    final authP = Provider.of<AuthP>(context);
    await authP.getPolicy();
    _isLoadingFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    final authP = Provider.of<AuthP>(context);

    Future<void> signUp() async {
      try {
        String firstName = _firstNameController.text;
        String lastName = _lastNameController.text;
        String email = _emailController.text;
        String confirmPassword = _confirmPasswordController.text;
        final valid = _formKey.currentState!.validate();
        _triggerPoilcyError = _isPolicyChecked;
        print(_isPolicyChecked);
        if (valid && !_isLoading && _isPolicyChecked) {
          setState(() {
            _isLoading = true;
          });
          FocusScope.of(context).requestFocus(FocusNode());

          await authP.signUp(firstName, lastName, email, confirmPassword,
              _isPolicyChecked, authP.myPolicy.id);
          showSucccessDialog(context);
        }

        setState(() {
          _isLoading = false;
        });
      } on ConflictException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showMyErroDialog(context, e.cause, () {
          Navigator.of(context).pop();
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showMyErroDialog(
            context, "Ett fel har uppstått!. Vänligen försök igen.", () {
          Navigator.of(context).pop();
        });
      }
    }

    return ChangeNotifierProvider(
      create: (_) => AuthP(),
      child: GestureDetector(
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
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Har redan ett konto',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: <Widget>[
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Skapa konto',
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange ditt förnamn';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Förnamn',
                            prefixIcon: const Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange ditt efternamn';
                            }

                            return null;
                          },
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Efternamn',
                            prefixIcon: const Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange din e-post adress';
                            }
                            if (!isValidEmail(value)) {
                              return 'Vänligen ange en korrekt e-postadress ex ex@e.com';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'E-post',
                            prefixIcon: const Icon(
                              Icons.mail,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vänligen ange ett lösenord';
                            }
                            if (value.length < 6) {
                              return 'Ditt lösenord måste vara minst 6 tecken långt';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Lösenord',
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != _passwordController.value.text) {
                              return 'Dina lösenord matchar inte';
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Skriv om lösenord',
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: Colors
                                      .blue, // Color when Checkbox is not selected
                                ),
                                child: Checkbox(
                                  value: _isPolicyChecked,
                                  checkColor:
                                      Colors.white, // Color of the check

                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isPolicyChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Jag godkänner',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                              ),
                              FutureBuilderWidget(
                                func: () {},
                                future: _isLoadingFirst ? getPolicy() : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // navigate to the policy page
                                        Navigator.of(context).pushNamed(
                                          Policy.routName,
                                          arguments: authP.myPolicy.text,
                                        );
                                      },
                                      child: Text(
                                        'Sekretesspolicy',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_triggerPoilcyError == false) ...[
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 16),
                                  child: Text(
                                    "Vänligen godkänn vårt policy",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .errorColor, // usually red
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]
                        ],
                      ),
                      const SizedBox(height: 30),
                      _isLoading
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
                                await signUp();
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
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Object?> showSucccessDialog(BuildContext context) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 80,
                  ),
                  const Text(
                    'Toppen!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Kontot har skapats, nu kan logga in',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // close the dialog
                      Navigator.of(context)
                          .pop(); // navigate back to login screen
                    },
                    child: const Text(
                      'Okej',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }
}
