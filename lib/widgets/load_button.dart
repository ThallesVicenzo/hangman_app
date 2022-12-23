import 'package:flutter/material.dart';
import 'package:hangman_app/widgets/text_widget.dart';

class LoadButton extends StatelessWidget {
  LoadButton(
      {required this.onPressed, required this.title, required this.isPressed});

  final VoidCallback? onPressed;
  final String title;
  final isPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  width: 3, color: isPressed ? Colors.red : Colors.white),
            ),
          ),
        ),
        onPressed: onPressed,
        child: TextWidget(
          title: title,
          fontSize: 25,
        ),
      ),
    );
  }
}
