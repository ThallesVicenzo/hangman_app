import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

Widget Letter(String character, bool hidden) {
  return Container(
    height: 65,
    width: 50,
    padding: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Visibility(
      visible: !hidden,
      child: TextWidget(
        title: character,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
