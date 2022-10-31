import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {

  TextWidget({required this.title, required this.fontSize, this.fontWeight = null});

  final String title;
  final double fontSize;
  final fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'PatrickHand',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}