import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/routes/named_routes.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:hangman_app/widgets/text_widget.dart';

import '../../services/hangman_api/hangman-model.dart';
import '../../services/shared_preferences/storage_service.dart';

class GameScreen extends StatefulWidget {
  GameScreen({@required this.hangmanDataFromApi, this.showPoints});

  final hangmanDataFromApi;
  final int? showPoints;

  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String token;
  late String hangmanString;

  late String guessLetter;
  var newHangmanData;
  var guessData;

  var hint;

  var hangmanSolution;
  var solution;

  var restartData;

  int totalHints = 3;
  int lives = 6;
  late int showPoints;
  late String? nickname;

  bool isPressed = false;
  bool isLoading = false;
  bool isVisible = true;
  bool disable = true;

  final _text = TextEditingController();

  late List<bool> keyboard; //essa Lista guarda os booleanos

  HangmanModel hangmanModel = HangmanModel();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  initState() {
    super.initState();
    keyboard = List.generate(26, (index) => false);
    showPoints = widget.showPoints == null ? 0 : widget.showPoints!;
    getUI(widget.hangmanDataFromApi);
    nickname = StorageService.getNickname();
    callGetSolution();
  }

  void getUI(dynamic hangmanData) {
    hangmanString = hangmanData['hangman'];
    token = hangmanData['token'];
  }

  void updateUI() {
    if (newHangmanData != null) {
      hangmanString = newHangmanData['hangman'];
      token = newHangmanData['token'];
      guessData = newHangmanData['correct'];
    }
  }

  void hintUI() {
    if (newHangmanData != null) {
      hint = newHangmanData['hint'];
      token = newHangmanData['token'];
    }
  }

  void solutionUI() {
    solution = hangmanSolution['solution'];
    token = hangmanSolution['token'];
  }

  Future<dynamic> getLetter(dynamic token, dynamic letter) async {
    newHangmanData = await hangmanModel.guessLetter(token, letter);
    return newHangmanData;
  }

  Future<dynamic> getSolution(dynamic token) async {
    hangmanSolution = await hangmanModel.getSolution(token);
    return hangmanSolution;
  }

  Future<dynamic> getHint(dynamic token) async {
    newHangmanData = await hangmanModel.getHint(token);
    return newHangmanData;
  }

  Future<dynamic> restartGame() async {
    restartData = await hangmanModel.createGame();
    return restartData;
  }

  Future callGetSolution() async {
    await getSolution(token);
    solutionUI();
  }

  Future<void> addHighscore() {
    return users.add({
      'highscore': showPoints,
      'nickname': nickname,
    });
  }

  Future updateToGameOver() async {
    if (guessData == false) {
      lives = lives - 1;
    }
    if (lives <= 0) {
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
                    checkIfNicknameIsNull(),
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
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        isLoading ? await restartGame() : null;
                        isLoading
                            ? Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                return GameScreen(
                                  hangmanDataFromApi: restartData,
                                );
                              }))
                            : null;
                        setState(() {
                          isLoading = false;
                        });
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
                        onPressed: () async {
                          if (isPressed == false) {
                            setState(() {
                              isLoading = true;
                            });
                            await highscoreButtonWithoutTextField();
                            await highscoreButtonWithTextField();
                            setState(() {
                              isLoading = false;
                              isPressed = true;
                              isVisible = false;
                            });
                          } else {
                            isVisible = true;
                            isLoading = false;
                            isPressed = false;
                          }
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
                        setState(() {
                          isLoading = true;
                        });
                        isLoading ? await restartGame() : null;
                        isLoading
                            ? Navigator.pushReplacementNamed(
                                context, NamedRoutes.gameHome)
                            : null;
                        setState(() {
                          isLoading = false;
                        });
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

  highscoreButtonWithTextField() async {
    if (nickname == null) {
      if (_errorText == null) {
        await addHighscore();
        await StorageService.setNickname(nickname!);
        return setState(() {
          isPressed = true;
          isVisible = false;
        });
      } else
        return null;
    } else
      return null;
  }

  highscoreButtonWithoutTextField() async {
    if (nickname != null) {
      await addHighscore();
      await StorageService.setNickname(nickname!);
    } else
      return null;
  }

  Future updateToNewGame() async {
    if (hangmanString == solution) {
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
                    checkIfNicknameIsNull(),
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
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        isLoading ? await restartGame() : null;
                        isLoading
                            ? Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                                return GameScreen(
                                  hangmanDataFromApi: restartData,
                                );
                              }))
                            : null;
                        setState(() {
                          isLoading = false;
                        });
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
                          if (isPressed == false) {
                            setState(() {
                              isLoading = true;
                            });
                            await highscoreButtonWithoutTextField();
                            await highscoreButtonWithTextField();
                            setState(() {
                              isLoading = false;
                              isPressed = true;
                              isVisible = false;
                            });
                          } else {
                            isVisible = true;
                            isLoading = false;
                            isPressed = false;
                          }
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
                        setState(() {
                          isLoading = true;
                        });
                        isLoading ? await restartGame() : null;
                        isLoading
                            ? Navigator.pushReplacementNamed(
                                context, NamedRoutes.gameHome)
                            : null;
                        setState(() {
                          isLoading = false;
                        });
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

  String? get _errorText {
    final text = _text.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length > 7) {
      return 'Can\'t have more than 7 characters';
    }
    return null;
  }

  int get changeTotalHints {
    if (lives == 3) {
      return totalHints = 2;
    }
    if (lives == 2) {
      return totalHints = 1;
    }
    if (lives == 1) {
      return totalHints = 0;
    }
    return totalHints;
  }

  checkIfNicknameIsNull() {
    if (nickname == null) {
      return Visibility(
        visible: isVisible,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _text,
            style: kTextButtonStyle,
            onChanged: (value) {
              nickname = value;
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Type your nickname here: ',
              errorText: _errorText,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  getIndexForLoadingInKeyboard(index) async {
    if (keyboard[index] == false) {
      setState(() {
        isLoading = true;
      });
      await updateHangmanString(index);
      setState(() {
        isLoading = false;
      });
    } else
      return null;
  }

  Future updateHangmanString(index) async {
    if (keyboard[index] == false) {
      guessLetter = kKeyboard[index];
      await getLetter(token, guessLetter);
      setState(() {
        updateUI();
        updateToGameOver();
        updateToNewGame();
        keyboard[index] = true;
      });
    } else {
      return null;
    }
  }

  Future updateUiWithHint() async {
    if (totalHints > 0 && lives > 1) {
      await getHint(token);
      hintUI();
      guessLetter = hint;
      await getLetter(token, hint);
      final index = kKeyboard.indexOf(hint as String);
      setState(() {
        updateUI();
        updateToNewGame();
        updateToGameOver();
        keyboard[index] = true;
      });
    } else {
      return null;
    }
  }

  get disableHint {
    if (lives == 1) {
      return disable = true;
    }
    if (isLoading == true) {
      return disable = true;
    }
    return disable = false;
  }

  Color getLoadingOrDisabledIconColor() {
    if (totalHints == 0) {
      return Colors.red;
    }
    if (isLoading == true) {
      return Colors.red;
    }
    if (lives <= 1) {
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
          Navigator.pushReplacementNamed(context, NamedRoutes.gameHome);
          return true;
        },
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(title: 'life = $lives', fontSize: 25),
                    TextWidget(title: '$showPoints', fontSize: 25),
                    AbsorbPointer(
                      absorbing: disableHint,
                      child: IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await updateUiWithHint();
                          setState(() {
                            lives = lives - 1;
                            isLoading = false;
                          });
                        },
                        icon: Icon(
                          Icons.lightbulb,
                          color: getLoadingOrDisabledIconColor(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Image.asset(
                  kImageList[lives],
                ),
              ),
              Center(
                child: Text(
                  '$hangmanString',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'PatrickHand',
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 7,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: keyboard.length,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: CustomTextButton(
                            isLoading: isLoading,
                            color: keyboard[index] ? Colors.grey : Colors.blue,
                            label: kKeyboard[index],
                            onPressed: () async {
                              getIndexForLoadingInKeyboard(index);
                            }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
