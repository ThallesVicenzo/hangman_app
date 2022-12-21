import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/services/tile/game_tile.dart';
import 'package:hangman_app/widgets/hang_image.dart';
import 'package:hangman_app/widgets/text_widget.dart';

import '../../widgets/letter.dart';
import '../../widgets/show_dialog_method.dart';

class GameScreen extends StatefulWidget {
  GameScreen({@required this.hangmanData, this.showPoints});

  final int? showPoints;
  final hangmanData;

  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  dynamic hangmanGame;
  String word = '';
  String hint = '';

  int tries = 0;
  int points = 0;
  int totalHints = 1;
  late int showPoints;

  bool isPressed = false;
  bool isVisible = false;
  bool disable = true;

  late List<bool> keyboard; //essa Lista guarda os booleanos

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  String documentId = '';

  @override
  initState() {
    super.initState();
    hangmanGame = widget.hangmanData;
    hangmanModel();
    keyboard = List.generate(26, (index) => false);
    showPoints = widget.showPoints == null ? 0 : widget.showPoints!;

    documentId = _auth.currentUser!.uid;
  }

  void hangmanModel() {
    word = hangmanGame['word'].toString().toUpperCase();
    hint = hangmanGame['hint'];
  }

  Future<void> addHighscore() {
    return users.add({
      'highscore': showPoints,
    });
  }

  /*Future<void> newGameButton() async {
    setState(() {
      isLoading = true;
    });
    isLoading ? await createGame() : null;
    isLoading
        ? Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return GameScreen(
            hangmanDataFromApi: restartData,
            showPoints: showPoints,
          );
        }))
        : null;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> highscoreButton() async {
    if (isPressed == false) {
      setState(() {
        isLoading = true;
      });
      await addHighscore();
      setState(() {
        isLoading = false;
        isPressed = true;
      });
    } else {
      isLoading = false;
      isPressed = false;
    }
  }

  Future<void> returnButton() async {
    setState(() {
      isLoading = true;
    });
    isLoading ? await createGame() : null;
    isLoading
        ? Navigator.pushReplacementNamed(context, NamedRoutes.gameHome)
        : null;
    setState(() {
      isLoading = false;
    });
  }

  Future updateToGameOver() async {
    if (guessData == false) {
      GameTile.lives--;
    }
    if (GameTile.lives <= 0) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                backgroundColor: kBackgroundColor,
                title: TextWidget(
                  title: 'You lose!',
                  fontSize: 50,
                ),
                content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextWidget(
                          title: 'The correct word was: $solution',
                          fontSize: 30,
                        ),
                      ],
                    )),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                width: 3,
                                color: isLoading ? Colors.red : Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () {
                        newGameButton();
                      },
                      child: TextWidget(
                        title: 'Restart',
                        fontSize: 25,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                width: 3,
                                color: isLoading ? Colors.red : Colors.white),
                          ),
                        ),
                        onPressed: () {
                          highscoreButton();
                        },
                        child: TextWidget(
                          title: 'Submit Highscore',
                          fontSize: 25,
                          isLoading: isLoading,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                width: 3,
                                color: isLoading ? Colors.red : Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        returnButton();
                      },
                      child: TextWidget(
                        title: 'Return to title',
                        fontSize: 25,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                ],
              );
            });
          });
    }
  }

  Future updateToNewGame() async {
    //if (hangmanString == solution) {
    showPoints++;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              backgroundColor: kBackgroundColor,
              title: TextWidget(
                title: 'Congratulations!',
                fontSize: 40,
              ),
              content: SingleChildScrollView(
                child: Column(children: [
                  TextWidget(
                      title: 'Your highscore is: $showPoints', fontSize: 25),
                ]),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              width: 3,
                              color: isLoading ? Colors.red : Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      newGameButton();
                    },
                    child: TextWidget(
                      title: 'Next Word',
                      fontSize: 25,
                      isLoading: isLoading,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              width: 3,
                              color: isLoading ? Colors.red : Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        highscoreButton();
                      },
                      child: TextWidget(
                        title: 'Submit Highscore',
                        fontSize: 25,
                        isLoading: isLoading,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              width: 3,
                              color: isLoading ? Colors.red : Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      returnButton();
                    },
                    child: TextWidget(
                      title: 'Return to title',
                      fontSize: 25,
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }*/

  Future updateUiWithHint() async {
    if (totalHints > 0 && tries < 5) {
      setState(() {
        isVisible = true;
        tries++;
        totalHints--;
      });
    } else {
      return null;
    }
  }

  get disableHint {
    if (tries == 5) {
      return disable = true;
    }
    if (totalHints == 0) {
      return disable = true;
    }
    return disable = false;
  }

  Color getNormalOrDisabledIconColor() {
    if (totalHints == 0) {
      return Colors.red;
    }
    if (tries >= 5) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          EnsureToReturnToHome(context);
          return true;
        },
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          EnsureToReturnToHome(context);
                        },
                        icon: Icon(
                          Icons.home,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      TextWidget(
                        title: '$showPoints',
                        fontSize: 30,
                      ),
                      IconButton(
                        onPressed: () {
                          updateUiWithHint();
                        },
                        icon: Icon(
                          size: 30,
                          Icons.lightbulb,
                          color: getNormalOrDisabledIconColor(),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isVisible,
                    child: TextWidget(title: hint, fontSize: 30),
                  ),
                  Stack(
                    children: [
                      HangImage(tries >= 0, 'assets/images/6.png'),
                      HangImage(tries >= 1, 'assets/images/5.png'),
                      HangImage(tries >= 2, 'assets/images/4.png'),
                      HangImage(tries >= 3, 'assets/images/3.png'),
                      HangImage(tries >= 4, 'assets/images/2.png'),
                      HangImage(tries >= 5, 'assets/images/1.png'),
                      HangImage(tries >= 6, 'assets/images/0.png'),
                    ],
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: word
                            .split('')
                            .map((e) => Letter(
                                e.toUpperCase(),
                                !GameTile.selectedChar
                                    .contains(e.toUpperCase())))
                            .toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    child: GridView.count(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8,
                      padding: EdgeInsets.all(8.0),
                      children: GameTile.kKeyboard.map((e) {
                        return RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: GameTile.selectedChar.contains(e)
                                ? Colors.grey
                                : Colors.blue,
                            child: TextWidget(
                              title: e,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            onPressed: GameTile.selectedChar.contains(e)
                                ? null
                                : () {
                                    setState(() {
                                      GameTile.selectedChar.add(e);
                                      if (!word
                                          .split('')
                                          .contains(e.toUpperCase())) {
                                        tries++;
                                      }
                                    });
                                  });
                      }).toList(),
                    ),
                  )
                ])),
      ),
    );
  }
}
