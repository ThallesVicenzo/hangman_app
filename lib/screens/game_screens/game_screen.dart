import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/game_screens/game_home_screen.dart';
import 'package:hangman_app/services/hangman-model.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:hangman_app/widgets/text_widget.dart';

class GameScreen extends StatefulWidget {
  GameScreen({@required this.hangmanDataFromApi, this.showPoints});

  final hangmanDataFromApi;
  int? showPoints;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var token;
  var hangmanString;

  var guessLetter;
  var newHangmanData;
  var guessData;

  var hint;

  var hangmanSolution;
  var solution;

  var restartData;

  dynamic highscores;

  int totalHints = 3;
  int lives = 6;
  late int showPoints;

  late List<bool> keyboard; //essa Lista guarda os booleanos

  HangmanModel hangmanModel = HangmanModel();

  @override
  initState() {
    super.initState();
    keyboard = List.generate(26, (index) => false);
    showPoints = widget.showPoints == null ? 0 : widget.showPoints!;
    getUI(widget.hangmanDataFromApi);
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

  void updateToGameOver() async {
    if (guessData == false) {
      lives = lives - 1;
    }
    if (lives <= 0) {
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: kBackgroundColor,
                title: TextWidget(
                  title: 'You lose!',
                  fontSize: 50,
                ),
                content: TextWidget(
                  title: 'The correct word was: $solution',
                  fontSize: 30,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await restartGame();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameScreen(hangmanDataFromApi: restartData, );
                      }));
                    },
                    child: TextWidget(
                      title: 'Restart',
                      fontSize: 25,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await restartGame();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameHomeScreen(restartData);
                      }));
                    },
                    child: TextWidget(
                      title: 'Return to title',
                      fontSize: 25,
                    ),
                  ),
                ],
              );
            });
      });
    }
  }

  Future updateToNewGame() async {
    if (hangmanString == solution)  {
      showPoints++;
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: kBackgroundColor,
                title: TextWidget(
                  title: 'Congratulations!',
                  fontSize: 40,
                ),
                content: TextWidget(
                    title: 'Your highscore is: $showPoints', fontSize: 25),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await restartGame();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameScreen(hangmanDataFromApi: restartData, showPoints: showPoints,);
                      }));
                    },
                    child: TextWidget(
                      title: 'New Game',
                      fontSize: 25,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await restartGame();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameHomeScreen(restartData);
                      }));
                    },
                    child: TextWidget(
                      title: 'Return to title',
                      fontSize: 25,
                    ),
                  ),
                ],
              );
            });
      });
    }
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
    } else if (keyboard[index] = true) return null;
  }

  Future updateUiWithHint() async {
    await getHint(token);
    hintUI();
    if (totalHints > 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: kBackgroundColor,
              title: TextWidget(
                title: 'The letter that you are looking for is: $hint',
                fontSize: 25,
              ),
              content: TextWidget(
                title: 'Warning: You have $totalHints more hint(s).',
                fontSize: 25,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    totalHints = totalHints - 1;
                    lives = lives - 1;
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    title: 'OK',
                    fontSize: 30,
                  ),
                ),
              ],
            );
          });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  IconButton(
                    onPressed: () async {
                      await updateUiWithHint();
                    },
                    icon: Icon(
                      Icons.lightbulb,
                      color: Colors.white,
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
                  fontSize: 50,
                  fontFamily: 'PatrickHand',
                  color: Colors.white,
                  letterSpacing: 10,
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
                          color: keyboard[index] ? Colors.grey : Colors.blue,
                          label: kKeyboard[index],
                          onPressed: () async {
                            await updateHangmanString(index);
                          }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
