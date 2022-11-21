import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';

import '../routes/named_routes.dart';

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
      Duration(milliseconds: 2500),
      () {
        setState(() {
          opacity = 0;
        });
      },
    );
  }

  final _auth = FirebaseAuth.instance;
  late final getRoute;

  double opacity = 1;

  Future getInitialRoute() async {
    if (_auth.currentUser != null) {
      return Navigator.pushReplacementNamed(context, NamedRoutes.gameHome);
    } else {
      return Navigator.pushReplacementNamed(context, NamedRoutes.authHome);
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
          if (opacity == 0) {
            getInitialRoute();
          }
        },
        child: Center(
          child: Image.asset('assets/images/gallow.png'),
        ),
      ),
    );
  }
}
