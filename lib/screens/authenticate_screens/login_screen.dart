import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../constants/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';
import '../game_screens/game_home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.hangmanData);

  final hangmanData;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;

  FirebaseAuthException? error;
  bool spinning = false;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinning,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextWidget(
                title: 'HANGMAN',
                fontSize: 45,
              ),
              Image(
                image: AssetImage(kHangmanGallow),
              ),
              TextField(
                style: kTextButtonStyle,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your email here: '),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: kTextButtonStyle,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your password here: '),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextButton(
                  label: 'Login',
                  onPressed: () async {
                    setState(() {
                      spinning = true;
                    });
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameHomeScreen(widget.hangmanData);
                      }));
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        spinning = false;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: kBackgroundColor,
                                title: TextWidget(
                                  title: e.message.toString(),
                                  fontSize: 25,
                                ),
                              );
                            });
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
