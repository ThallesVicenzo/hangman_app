import 'dart:async';
import 'package:flutter/material.dart';

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

        setState ((){
          opacity = 0;
        });

      },
    );
  }

  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff421b9c),
      body: AnimatedOpacity(duration: kThemeAnimationDuration, opacity: opacity, onEnd: (){
        if(opacity == 0){
          Navigator.of(context).pushReplacementNamed(NamedRoutes.home);
        }
      },
      child: Center(child: Image.asset('assets/images/hang_icon.png'),),),
    );
  }
}
