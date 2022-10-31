import 'package:flutter/material.dart';

import '../screens/game_screen.dart';
import '../screens/highscore_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import 'named_routes.dart';

class Pages {
  static Map<String, WidgetBuilder> all(BuildContext context) {
    return {
      NamedRoutes.home: (context) => HomeScreen(null),
      NamedRoutes.game: (context) => GameScreen(null),
      NamedRoutes.highscores: (context) => const HighScoreScreen(),
      NamedRoutes.splash: (context) => const SplashScreen(),
    };
  }
}