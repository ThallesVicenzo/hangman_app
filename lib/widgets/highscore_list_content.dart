import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

class HighscoreListContent extends StatelessWidget {
  HighscoreListContent(
      {@required this.title1,
        @required this.title2,
        @required this.title3,
        @required this.fontSize,
        this.fontWeight = null});

  final title1;
  final title2;
  final title3;

  final fontWeight;
  final fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons)
            TextWidget(title: title1, fontSize: fontSize, fontWeight: fontWeight),
            TextWidget(title: title2, fontSize: fontSize, fontWeight: fontWeight),
            TextWidget(title: title3, fontSize: fontSize, fontWeight: fontWeight),
          ],
        ),
      ),
    );
  }
}