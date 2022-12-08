import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_app/screens/authenticate_screens/auth_home_screen.dart';
import 'package:hangman_app/screens/game_screens/game_screen.dart';
import '../../constants/constants.dart';
import '../../routes/named_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class GameHomeScreen extends StatefulWidget {
  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  var hangmanString;
  String nickname = '';
  String? userId;

  final _auth = FirebaseAuth.instance;
  final _text = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
  }

  signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AuthHomeScreen();
    }));
  }

  String? get _errorText {
    final text = _text.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 7) {
      return 'Can\'t have more than 7 characters';
    }
    return null;
  }

  typeNickname() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            backgroundColor: kBackgroundColor,
            title: TextWidget(
              title: 'Please type your nickname',
              fontSize: 30,
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _text,
                style: kTextButtonStyle,
                onChanged: (value) {
                  nickname = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Type your nickname here: ',
                  errorText: _errorText,
                ),
              ),
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
                  onPressed: () async {
                    if (_errorText == null) {
                      await addNickname();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameScreen(
                          hangmanDataFromApi: hangmanString,
                        );
                      }));
                    }
                  },
                  child: TextWidget(
                    title: 'Confirm',
                    fontSize: 20,
                  )),
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
                    title: 'Cancel',
                    fontSize: 20,
                  )),
            ],
          );
        });
      },
    );
  }

  Future<void> addNickname() {
    final setNickname = <String, String>{'nickname': nickname};
    return users.doc(userId).set(setNickname);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: TextWidget(
                    title: 'Are you sure you want to close this app?',
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
                          SystemNavigator.pop();
                        },
                        child: TextWidget(
                          title: 'Yes',
                          fontSize: 25,
                        )),
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
                          title: 'No',
                          fontSize: 25,
                        )),
                  ],
                );
              });
          return true;
        },
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: kBackgroundColor,
                              title: TextWidget(
                                title:
                                    'Are you sure that you want to logout?',
                                fontSize: 25,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    signOut();
                                  },
                                  child: TextWidget(
                                    title: 'Yes',
                                    fontSize: 30,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    title: 'No',
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Image(
                      image: AssetImage(kLogout),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: TextWidget(
                      title: 'HANGMAN',
                      fontSize: 50,
                    ),
                  ),
                  Container(),
                ],
              ),
              Image(
                image: AssetImage(kHangmanGallow),
              ),
              CustomTextButton(
                  width: 130,
                  label: 'Start',
                  fontSize: 20,
                  onPressed: () {
                    typeNickname();
                  }),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextButton(
                    label: 'High Scores',
                    fontSize: 20,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.highscores,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
