import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

class HighscoreListContent extends StatelessWidget {
  HighscoreListContent(
      {@required this.title1,
        @required this.title2,
        @required this.title3,
        @required this.fontSize});

  final title1;
  final title2;
  final title3;

  final fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextWidget(title: title1, fontSize: fontSize),
        TextWidget(title: title2, fontSize: fontSize),
        TextWidget(title: title3, fontSize: fontSize),
      ],
    );
  }
}