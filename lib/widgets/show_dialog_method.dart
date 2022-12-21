import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

import '../constants/constants.dart';
import '../routes/named_routes.dart';

void EnsureToReturnToHome(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          title: TextWidget(
            title:
            'Are you sure you want to return to home?',
            fontSize: 30,
          ),
          actions: [
            TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                      side: BorderSide(
                          width: 3,
                          color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.gameHome,
                  );
                },
                child: TextWidget(
                  title: 'Yes',
                  fontSize: 25,
                )),
            TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                      side: BorderSide(
                          width: 3,
                          color: Colors.white),
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
}