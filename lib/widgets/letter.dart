import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

Widget Letter(String character, bool hidden) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        height: 65,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Visibility(
          visible: !hidden,
          child: Center(
            child: TextWidget(
              title: character,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
