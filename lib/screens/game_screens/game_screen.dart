import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/services/tile/game_tile.dart';
import 'package:hangman_app/widgets/hang_image.dart';
import 'package:hangman_app/widgets/load_button.dart';
import 'package:hangman_app/widgets/text_widget.dart';

import '../../routes/named_routes.dart';
import '../../services/hangman_json/json-request.dart';
import '../../widgets/letter.dart';
import '../../widgets/show_dialog_method.dart';

extension CharSorting on String {
  String sort() {
    final charList = this.split('');
    charList.sort();

    return charList.join();
  }
}

class GameScreen extends StatefulWidget {
  GameScreen({@required this.hangmanData, this.showPoints});

  final int? showPoints;
  final hangmanData;

  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  dynamic hangmanGame;
  late List<dynamic> listData;

  String word = '';
  String hint = '';
  String nickname = '';

  int tries = 0;
  int totalHints = 1;

  late int showPoints;

  bool isLoading = false;
  bool isVisible = false;
  bool isPressed = false;
  bool disable = true;

  List<String> get filterOnWord =>
      LinkedHashSet<String>.from(word.toUpperCase().split('')).toList();

  bool get finishedGame =>
      gameTile.correctChar.join().sort().toUpperCase() ==
      filterOnWord.join().sort().toUpperCase();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference highscores =
      FirebaseFirestore.instance.collection('highscores');

  final _auth = FirebaseAuth.instance;

  HangmanJsonRequest jsonRequest = HangmanJsonRequest();

  String documentId = '';

  late final docData;

  late final GameTile gameTile;

  @override
  initState() {
    super.initState();
    hangmanGame = widget.hangmanData;
    documentId = _auth.currentUser!.uid;
    gameTile = GameTile();
    hangmanModel();
    showPoints = widget.showPoints == null ? 0 : widget.showPoints!;
    getNickname();
  }

  void hangmanModel() {
    word = hangmanGame['word'].toString().toUpperCase();
    hint = hangmanGame['hint'];
  }

  Future<dynamic> jsonData() async {
    listData = await jsonRequest.loadJson();
    return listData;
  }

  dynamic listDataRandomizer() async {
    await jsonData();
    final _random = new Random();
    hangmanGame = listData[_random.nextInt(listData.length)];
    print(hangmanGame);
    return hangmanGame;
  }

  Future<dynamic> getNickname() async {
    await users.doc(documentId).get().then((value) {
      nickname = value.get('nickname');
    });
    return nickname;
  }

  Future<void> addHighscore() {
    final setData = <String, dynamic>{
      'nickname': nickname,
      'highscore': showPoints,
    };
    return highscores.doc(documentId).set(setData);
  }

  Future<Future<Object?>?> newGameButton(int highscore) async {
    if (isLoading == false) {
      await listDataRandomizer();
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
        return GameScreen(
          hangmanData: hangmanGame,
          showPoints: highscore,
        );
      }));
    } else {
      return null;
    }
  }

  Future<void> highscoreButton() async {
    if (isPressed == false) {
      await addHighscore();
    } else {
      return null;
    }
  }

  Future? returnButton() {
    if (isLoading == false) {
      return Navigator.pushReplacementNamed(context, NamedRoutes.gameHome);
    } else {
      isLoading = false;
    }
    return null;
  }

  Future updateToGameOver() async {
    if (tries == 6) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, setState) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: TextWidget(
                    title: 'You lose!',
                    fontSize: 50,
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: [
                      TextWidget(
                        title: 'The correct word was: $word',
                        fontSize: 30,
                      ),
                      Visibility(
                          visible: isPressed,
                          child: TextWidget(
                            title: 'Highscore submitted!',
                            fontSize: 20,
                          )),
                    ],
                  )),
                  actions: [
                    LoadButton(
                        isPressed: isLoading,
                        onPressed: () {
                          newGameButton(0);
                        },
                        title: 'New Game'),
                    LoadButton(
                        isPressed: isPressed,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          highscoreButton();
                          setState(() {
                            isLoading = false;
                            isPressed = true;
                          });
                        },
                        title: 'Submit highscore'),
                    LoadButton(
                        isPressed: isLoading,
                        onPressed: () {
                          returnButton();
                        },
                        title: 'Return to title'),
                  ],
                ),
              );
            });
          });
    }
  }

  int addPoints(){
    if(tries == 0 && totalHints == 1) {
      return showPoints = showPoints + 10;
    }
    if(totalHints == 1){
      return showPoints = showPoints + 5;
    }
    return showPoints++;
  }

  Future updateToNewGame() async {
    if (finishedGame) {
      addPoints();
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
                    Visibility(
                        visible: isPressed,
                        child: TextWidget(
                          title: 'Highscore submitted!',
                          fontSize: 20,
                        )),
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
                        newGameButton(showPoints);
                      },
                      child: TextWidget(
                        title: 'Next Word',
                        fontSize: 25,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                  LoadButton(
                      isPressed: isPressed,
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        highscoreButton();
                        setState(() {
                          isLoading = false;
                          isPressed = true;
                        });
                      },
                      title: 'Submit highscore'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(width: 3, color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () {
                        returnButton();
                      },
                      child: TextWidget(
                        title: 'Return to title',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              );
            });
          });
    }
  }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: word
                        .split('')
                        .map((e) => Letter(e.toUpperCase(),
                            !gameTile.selectedChar.contains(e.toUpperCase())))
                        .toList(),
                  ),
                  SizedBox(
                    height: 250,
                    child: GridView.count(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8,
                      padding: EdgeInsets.all(8.0),
                      children: gameTile.kKeyboard.map((e) {
                        return RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: gameTile.selectedChar.contains(e)
                                ? Colors.grey
                                : Colors.blue,
                            child: TextWidget(
                              title: e,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            onPressed: gameTile.selectedChar.contains(e)
                                ? null
                                : () {
                                    setState(() {
                                      gameTile.selectedChar.add(e);
                                      if (!word
                                          .split('')
                                          .contains(e.toUpperCase())) {
                                        tries++;
                                      } else {
                                        gameTile.correctChar.add(e);
                                      }
                                      updateToGameOver();
                                      updateToNewGame();

                                      print(word);
                                      print(gameTile.correctChar);
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
