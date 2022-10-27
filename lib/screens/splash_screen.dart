import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/home_screen.dart';

import '../routes/named_routes.dart';
import '../services/hangman-model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 1500),
      () {
        setState(() {
          opacity = 0;
        });
      },
    );
  }

  var hangmanData;
  double opacity = 1;

  Future<dynamic> getDataFromService() async {
    hangmanData = await HangmanModel().createGame();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(hangmanData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: AnimatedOpacity(
        duration: kThemeAnimationDuration,
        opacity: opacity,
        onEnd: () {
          if (opacity == 0) {
            getDataFromService();
          }
        },
        child: Center(
          child: Image.asset('assets/images/gallow.png'),
        ),
      ),
    );
  }
}
