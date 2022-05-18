import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {

  TextWidget({required this.title, required this.fontSize});

  final String title;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'PatrickHand',
        fontSize: fontSize
      ),
    );
  }
}