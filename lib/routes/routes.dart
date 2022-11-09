import 'package:flutter/material.dart';
import 'package:hangman_app/screens/authenticate_screens/auth_home_screen.dart';
import 'package:hangman_app/screens/authenticate_screens/login_screen.dart';
import 'package:hangman_app/screens/authenticate_screens/sign_in_screen.dart';

import '../screens/game_screens/game_screen.dart';
import '../screens/game_screens/highscore_screen.dart';
import '../screens/game_screens/game_home_screen.dart';
import '../screens/splash_screen.dart';
import 'named_routes.dart';

class Pages {
  static Map<String, WidgetBuilder> all(BuildContext context) {
    return {
      NamedRoutes.gameHome: (context) => GameHomeScreen(null, null),
      NamedRoutes.game: (context) => GameScreen(null, null, null),
      NamedRoutes.highscores: (context) => HighScoreScreen(),
      NamedRoutes.splash: (context) => const SplashScreen(),
      NamedRoutes.authHome: (context)  => AuthHomeScreen(),
      NamedRoutes.signIn: (context) => SignInScreen(null),
      NamedRoutes.login: (context) => LoginScreen(),
    };
  }
}