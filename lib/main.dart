import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hangman_app/routes/named_routes.dart';
import 'package:hangman_app/routes/routes.dart';
import 'package:hangman_app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await Firebase.initializeApp();
  runApp(HangmanApp());
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
