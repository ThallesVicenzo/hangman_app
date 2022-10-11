import 'package:flutter/material.dart';
import 'package:hangman_app/screens/game_screen.dart';
import '../constants/constants.dart';
import '../routes/named_routes.dart';
import '../services/hangman-model.dart';
import '../widgets/rounded_button.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var hangmanDataFromApi;

  @override
  initState() {
    super.initState();
    getDataFromService();
  }

  Future<dynamic> getDataFromService() async {
    hangmanDataFromApi = await HangmanModel().createGame();
    return hangmanDataFromApi;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: Scaffold(
          backgroundColor: const Color(0xff421b9c),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextWidget(
                title: 'HANGMAN',
                fontSize: 50,
              ),
              const Image(
                image: AssetImage(kLogo),
              ),
              Column(
                children: [
                  RoundedButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                    title: 'Start',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return GameScreen(
                          hangmanDataFromApi
                        );
                      }));
                    },
                    style: kTextStyle
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                    title: 'High Scores',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.highscores,
                      );
                    },
                    style: kTextStyle,
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
