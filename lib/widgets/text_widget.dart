import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {required this.title,
      required this.fontSize,
      this.fontWeight = null,
      this.isLoading = false});

  final String title;
  final double fontSize;
  final fontWeight;
  final isLoading;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isLoading ? Colors.red : Colors.white,
        fontFamily: 'PatrickHand',
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
