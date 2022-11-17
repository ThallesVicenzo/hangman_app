import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/highscore_list_content.dart';

class HighscoreTile extends StatelessWidget {
  HighscoreTile({required this.documentID});

  final documentID;

  @override
  Widget build(BuildContext context) {
    CollectionReference highscores =
        FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: highscores.doc(documentID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    HighscoreListContent(
                        title1: data['nickname'],
                        title2: data['highscore'].toString(),
                        fontSize: 28.0,
                        fontWeight: FontWeight.w300),
                  ],
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
