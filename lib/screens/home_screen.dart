import 'package:flutter/material.dart';
import '../routes/named_routes.dart';
import '../widgets/rounded_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: Scaffold(
          backgroundColor: const Color(0xff421b9c),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'HANGMAN',
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: 'PatrickHand',
                  fontSize: 60,
                ),
              ),
              const Image(
                image: AssetImage('assets/images/hang_icon.png'),
              ),
              Column(
                children: [
                  RoundedButton(
                    color: Colors.blue,
                    title: 'Start',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.game,
                      );
                    },
                    style: const TextStyle(fontFamily: 'PatrickHand', color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                    color: Colors.blue,
                    title: 'High Scores',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.highscores,
                      );
                    },
                    style: const TextStyle(fontFamily: 'PatrickHand', color: Colors.white, fontSize: 25),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
