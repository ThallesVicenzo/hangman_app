import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../constants/constants.dart';
import '../../routes/named_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   String email = '';
   String password = '';

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
                    hintText: 'Escreva seu email aqui'),
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
                    hintText: 'Escreva sua senha aqui'),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextButton(
                  label: 'Logar',
                  onPressed: () async {
                    setState(() {
                      spinning = true;
                    });
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      Navigator.pushReplacementNamed(
                          context, NamedRoutes.gameHome);
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
