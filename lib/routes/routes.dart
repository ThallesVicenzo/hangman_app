import 'package:flutter/material.dart';
import 'package:hangman_app/screens/authenticate_screens/sign_in_screen.dart';

import '../screens/game_screens/game_screen.dart';
import '../screens/game_screens/highscore_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import 'named_routes.dart';

class Pages {
  static Map<String, WidgetBuilder> all(BuildContext context) {
    return {
      NamedRoutes.home: (context) => HomeScreen(null, null),
      NamedRoutes.game: (context) => GameScreen(null, null, null),
      NamedRoutes.highscores: (context) => HighScoreScreen(),
      NamedRoutes.splash: (context) => const SplashScreen(),
      NamedRoutes.login: (context) => SignInScreen(null),
    };
  }
}