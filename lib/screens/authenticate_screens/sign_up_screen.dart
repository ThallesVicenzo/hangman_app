import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../routes/named_routes.dart';
import '../../services/shared_preferences/storage_service.dart';
import '../../widgets/text_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String nickname = '';
  String email = '';
  String password = '';

  bool spinning = false;

  final _auth = FirebaseAuth.instance;
  final _controller = TextEditingController();

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Nickname can\'t be empty';
    }
    if (text.length > 7) {
      return 'Nickname can\'t have more than 7 characters';
    }
    return null;
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
                  controller: _controller,
                  style: kTextButtonStyle,
                  onChanged: (value) {
                    nickname = value;
                    (_) => setState(() {});
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Type your nickname here: ',
                  ),
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
                    hintText: 'Type your email here: ',
                  ),
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
                    hintText: 'Type your password here: ',
                  ),
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
                      if (_errorText == null) {
                        await StorageService.setNickname(nickname);
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushReplacementNamed(
                            context, NamedRoutes.gameHome);
                      } else {
                        spinning = false;
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: kBackgroundColor,
                                title: TextWidget(
                                  title: _errorText.toString(),
                                  fontSize: 25,
                                ),
                              );
                            });
                      }
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
      ),
    );
  }
}
