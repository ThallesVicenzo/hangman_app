import 'package:flutter/material.dart';
import 'package:hangman_app/routes/named_routes.dart';
import 'package:hangman_app/routes/routes.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: NamedRoutes.splash,
      routes: Pages.all(context),
    );
  }
}
