import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/login_screen.dart';
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
    getDataFromService();
  }

  var hangmanData;
  double opacity = 0;

  Future<dynamic> getDataFromService() async {
    setState(() {
      opacity = 1;
    });
    hangmanData = await HangmanModel().createGame();
    setState(() {
      opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: AnimatedOpacity(
        duration: kThemeAnimationDuration,
        opacity: opacity,
        onEnd: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen(hangmanData);
          }));
        },
        child: Center(
          child: Image.asset('assets/images/gallow.png'),
        ),
      ),
    );
  }
}
