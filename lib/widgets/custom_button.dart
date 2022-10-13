import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.label,
    required this.onPressed,
    this.width = 130,
    this.height = 60,
    this.fontSize = 16,
    Key? key,
  }) : super(key: key);

  final String label;

  final VoidCallback? onPressed;

  final double height;

  final double width;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blue)),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: kTextButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
