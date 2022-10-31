import 'package:flutter/material.dart';
import 'package:hangman_app/screens/game_screen.dart';
import '../constants/constants.dart';
import '../routes/named_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.firstHangmanData);

  final firstHangmanData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextWidget(
              title: 'HANGMAN',
              fontSize: 50,
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
                    return GameScreen(widget.firstHangmanData);
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
