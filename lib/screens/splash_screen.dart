import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';
import 'package:hangman_app/screens/authenticate_screens/auth_home_screen.dart';
import 'package:hangman_app/screens/game_screens/game_home_screen.dart';

import '../services/hangman_api/hangman-model.dart';

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

  final _auth = FirebaseAuth.instance;
  late final getRoute;

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

  Future getInitialRoute() async {
    if(_auth.currentUser != null){
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return GameHomeScreen(hangmanData);
          }));
    } else {
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return AuthHomeScreen(hangmanData);
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: AnimatedOpacity(
        duration: kThemeAnimationDuration,
        opacity: opacity,
        onEnd: () {
          getInitialRoute();
        },
        child: Center(
          child: Image.asset('assets/images/gallow.png'),
        ),
      ),
    );
  }
}
