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
  String email = '';
  String password = '';
  String nickname = '';
  String? userId;

  bool spinning = false;

  final _text = TextEditingController();
  final _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<String?>? _errorText() async {
    final text = _text.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length <= 2) {
      return 'Can\'t have less than 3 characters';
    }
    if (text.length > 7) {
      return 'Can\'t have more than 7 characters';
    }
    final queryNickname = await users.where('nickname', isEqualTo: text).get();
    final index = queryNickname.docs.indexWhere((e) => e.get('nickname') == text);
    if(index != -1){
      return 'Nickname already exist!';
    }
    return null;
  }

  Map setUserData(String email, String password, String nickname) {
    Map userData = <String, String>{
      'email': email,
      'password': password,
      'nickname': nickname,
    };
    return userData;
  }

  Future validateFields() async {
    final errorText = await _errorText();
    if (errorText != null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: kBackgroundColor,
              title: TextWidget(
                title: errorText,
                fontSize: 30,
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(width: 3, color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    title: 'OK',
                    fontSize: 20,
                  ),
                ),
              ],
            );
          });
    }
    else{
      try {
        userId = _auth.currentUser?.uid;
        await users.doc(userId).set(setUserData(email, password, nickname));
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushReplacementNamed(context, NamedRoutes.gameHome);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinning,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
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
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  style: kTextButtonStyle,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your email here: ',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  style: kTextButtonStyle,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your password here: ',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextButton(
                  label: 'Register',
                  onPressed: () async {
                    setState(() {
                      spinning = true;
                    });
                    await validateFields();
                    setState(() {
                      spinning = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
