import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({Key? key}) : super(key: key);

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.house,
              color: Colors.white,
              size: 30,
            ),
            const Text(
              'High Scores',
              style: TextStyle(
                  fontFamily: 'PatrickHand', color: Colors.white, fontSize: 35),
            ),
            Column(
              children: const [Text('Rank')],
            )
          ],
        ),
      ),
    );
  }
}
