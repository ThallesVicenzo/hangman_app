import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_app/screens/authenticate_screens/auth_home_screen.dart';
import 'package:hangman_app/screens/game_screens/game_screen.dart';
import 'package:hangman_app/services/hangman_json/json-request.dart';
import '../../constants/constants.dart';
import '../../routes/named_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class GameHomeScreen extends StatefulWidget {
  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  final _auth = FirebaseAuth.instance;
  HangmanJsonRequest jsonRequest = HangmanJsonRequest();
  late List<dynamic> listData;
  dynamic hangmanData;

  signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AuthHomeScreen();
    }));
  }

  Future<dynamic> jsonData() async {
    listData = await jsonRequest.loadJson();
    return listData;
  }

  dynamic listDataRandomizer() async {
    await jsonData();
    final _random = new Random();
    hangmanData = listData[_random.nextInt(listData.length)];
    return hangmanData;
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
                    title: 'Você tem certeza que quer fechar o aplicativo?',
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
                          title: 'Sim',
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
                          title: 'Cancelar',
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
                                title: 'Você tem certeza que quer deslogar?',
                                fontSize: 25,
                              ),
                              actions: [
                                TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            width: 3, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    signOut();
                                  },
                                  child: TextWidget(
                                    title: 'Sim',
                                    fontSize: 30,
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            width: 3, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    title: 'Cancelar',
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage(kLogout),
                        color: Colors.white,
                      ),
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
                  label: 'Novo jogo',
                  fontSize: 20,
                  onPressed: () async {
                    await listDataRandomizer();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return GameScreen(
                        hangmanData: hangmanData,
                      );
                    }));
                  }),
              CustomTextButton(
                label: 'Ranking',
                fontSize: 20,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.highscores,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
