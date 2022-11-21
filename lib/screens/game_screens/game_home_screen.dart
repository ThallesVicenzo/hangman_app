import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/screens/authenticate_screens/auth_home_screen.dart';
import 'package:hangman_app/screens/game_screens/game_screen.dart';
import '../../constants/constants.dart';
import '../../routes/named_routes.dart';
import '../../services/hangman_api/hangman-model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class GameHomeScreen extends StatefulWidget {
  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  @override
  initState() {
    super.initState();
    hangmanApiRequest();
  }

  var hangmanString;

  final _auth = FirebaseAuth.instance;
  HangmanModel hangmanModel = HangmanModel();

  Future<dynamic> hangmanApiRequest() async {
    hangmanString = await hangmanModel.createGame();
    return hangmanString;
  }

  signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AuthHomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
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
                              title: 'Are you sure that you want to logout?',
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(kLogout),
                      color: Colors.white,
                    ),
                  ),
                ),
                TextWidget(
                  title: 'HANGMAN',
                  fontSize: 50,
                ),
                Visibility(
                  visible: false,
                  child: TextWidget(title: 'placeHolder', fontSize: 1),
                ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GameScreen(hangmanDataFromApi: hangmanString);
                  }));
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
    );
  }
}
