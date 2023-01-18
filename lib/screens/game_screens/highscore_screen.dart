import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/tile/highscore_tile.dart';
import '../../widgets/highscore_list_content.dart';
import 'game_home_screen.dart';

class HighScoreScreen extends StatefulWidget {
  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> highscore_docIds = [];
  late final Future? getDocIds;
  String documentId = '';

  @override
  void initState() {
    super.initState();
    getDocIds = getDocId();
  }

  Future getDocId() async {
    await firestore
        .collection('highscores')
        .orderBy('highscore', descending: true)
        .limit(10)
        .get()
        .then((value) => value.docs.forEach((element) {
              highscore_docIds.add(element.reference.id);
            }));
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
                        return GameHomeScreen();
                      }));
                    },
                  ),
                  SizedBox(width: 70),
                  TextWidget(title: 'Ranking', fontSize: 45),
                ],
              ),
            ),
            HighscoreListContent(
              title1: 'Apelido',
              title2: 'Highscore',
              fontSize: 35.0,
            ),
            FutureBuilder(
                future: getDocIds,
                builder: (context, snapshots) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: highscore_docIds.length,
                        itemBuilder: (context, index) {
                          return HighscoreTile(
                              documentID: highscore_docIds[index]);
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
