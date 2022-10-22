import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/services/hangman-model.dart';
import 'package:hangman_app/widgets/custom_button.dart';
import 'package:hangman_app/widgets/text_widget.dart';

class GameScreen extends StatefulWidget {
  GameScreen(this.hangmanDataFromApi);

  final hangmanDataFromApi;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var token;
  var hangmanString;

  var guessLetter;
  var letterData;
  var guessData;

  int lives = 6;
  int highscore = 0;

  HangmanModel hangmanModel = HangmanModel();

  late List<bool> keyboard; //essa Lista guarda os booleanos

  @override
  initState() {
    super.initState();
    keyboard = List.generate(26, (index) => false);
    getUI(widget.hangmanDataFromApi);
  }

  void getUI(dynamic hangmanData) {
    hangmanString = hangmanData['hangman'];
    token = hangmanData['token'];
  }

  Future<dynamic> getLetter(dynamic token, dynamic letter) async {
    letterData = await HangmanModel().guessLetter(token, letter);
    return letterData;
  }

  void updateUI() {
    if (letterData != null) {
      hangmanString = letterData['hangman'];
      token = letterData['token'];
      guessData = letterData['correct'];
    }
  }

  void updateHangImage() async {
    if(guessData == false){
      lives = lives - 1;
    }
    else if(lives == 0){
      Navigator.pop(context);
    }
  }

  Future updateHangmanString(index) async {
    if (keyboard[index] == false) {
      guessLetter = kKeyboard[index];
      await getLetter(token, guessLetter);
      setState(() {
        updateUI();
        updateHangImage();
        keyboard[index] = true;
      });
    } else if (keyboard[index] = true) return null;
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
                  TextWidget(title: '$highscore', fontSize: 25),
                  Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Expanded(child: Image.asset(kImageList[lives])),
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
