import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_app/routes/named_routes.dart';
import '../../constants/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_widget.dart';

class AuthHomeScreen extends StatefulWidget {
  @override
  State<AuthHomeScreen> createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: TextWidget(
                    title: 'Are you sure you want to close this app?',
                    fontSize: 30,
                  ),
                  actions: [
                    TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(width: 3, color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: TextWidget(
                          title: 'Yes',
                          fontSize: 25,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(width: 3, color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextWidget(
                          title: 'No',
                          fontSize: 25,
                        )),
                  ],
                );
              });
          return true;
        },
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
                    label: 'SignUp',
                    fontSize: 20,
                    onPressed: () {
                      Navigator.pushNamed(context, NamedRoutes.signUp);
                    },
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
