import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/home_screen.dart';
import 'package:hangman_app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/highscore_list_content.dart';

class HighScoreScreen extends StatefulWidget {

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(size: 35, Icons.house),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen(null);
                      }));
                    },
                  ),
                  SizedBox(width: 35),
                  TextWidget(title: 'High Scores', fontSize: 45),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                children: [
                  HighscoreListContent(
                    title1: 'Rank',
                    title2: 'Date',
                    title3: 'Score',
                    fontSize: 30.0,
                  ),
                  HighscoreListContent(
                      title1: '🥇1',
                      title2: '20-Mar-31',
                      title3: '1',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300),
                  HighscoreListContent(
                      title1: '🥈2',
                      title2: '20-Mar-31',
                      title3: '1',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300),
                  HighscoreListContent(
                      title1: '🥉3',
                      title2: '20-Mar-31',
                      title3: '1',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  HighscoreListContent(
                      title1: '4',
                      title2: '20-Mar-31',
                      title3: '1',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300),
                  HighscoreListContent(
                      title1: '5',
                      title2: '20-Mar-31',
                      title3: '1',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
