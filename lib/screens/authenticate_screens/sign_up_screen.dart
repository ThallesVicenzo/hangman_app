import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../routes/named_routes.dart';
import '../../widgets/text_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String nickname;
  late String email;
  late String password;

  bool spinning = false;

  final _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final _text = TextEditingController();
    bool _validate = false;

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
                controller: _text,
                style: kTextButtonStyle,
                onChanged: (value) {
                  nickname = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Type your nickname here: ',
                  errorText: _validate ? null : 'Value Can\'t Be Empty',
                ),
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
                height: 10,
              ),
              CustomTextButton(
                label: 'Register',
                onPressed: () async {
                  setState(() {
                    spinning = true;
                    _validate = true;
                  });
                  try {
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushReplacementNamed(
                        context, NamedRoutes.gameHome);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      spinning = false;
                    });
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
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
