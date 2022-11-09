import 'package:flutter/material.dart';
import 'package:hangman_app/screens/authenticate_screens/login_screen.dart';
import 'package:hangman_app/screens/authenticate_screens/sign_in_screen.dart';
import '../../constants/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class AuthHomeScreen extends StatefulWidget {
  AuthHomeScreen(this.hangmanData);

  final hangmanData;

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginScreen(widget.hangmanData);
                  }));
                }),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomTextButton(
                  label: 'SignIn',
                  fontSize: 20,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignInScreen(widget.hangmanData);
                    }));
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