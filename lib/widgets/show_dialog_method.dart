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
            'Você tem certeza que quer voltar para o menu?',
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
                  title: 'Sim',
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
                  title: 'Não',
                  fontSize: 25,
                )),
          ],
        );
      });
}