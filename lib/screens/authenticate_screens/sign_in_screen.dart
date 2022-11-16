import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/game_screens/game_home_screen.dart';
import 'package:hangman_app/services/storage_service.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../widgets/text_widget.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen(this.hangmanData);

  final hangmanData;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late String nickname;
  late String email;
  late String password;

  bool spinning = false;

  final _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addNickname() {
    return users
        .add({
      'nickname': nickname,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinning,
      child: Scaffold(
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
                  nickname = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your nickname here: '),
              ),
              SizedBox(
                height: 20,
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
                  });
                  try {
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    addNickname();
                    StorageService.setNickname(nickname);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GameHomeScreen(widget.hangmanData);
                    }));
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
