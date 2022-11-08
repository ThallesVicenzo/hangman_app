import 'package:flutter/material.dart';
import 'package:hangman_app/screens/authenticate_screens/login_screen.dart';

import '../../constants/constants.dart';
import '../../routes/named_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class AuthHomeScreen extends StatefulWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  State<AuthHomeScreen> createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextWidget(
              title: 'HANGMAN',
              fontSize: 50,
            ),
            Image(
              image: AssetImage(kHangmanGallow),
            ),
            CustomTextButton(
                width: 130,
                label: 'Login',
                fontSize: 20,
                onPressed: () {
                  Navigator.pushNamed(context, NamedRoutes.login);
                }),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomTextButton(
                  label: 'High Scores',
                  fontSize: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, NamedRoutes.signIn);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
