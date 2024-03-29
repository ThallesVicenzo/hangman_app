import 'package:flutter/material.dart';
import 'package:hangman_app/constants/constants.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.width = 130,
    this.height = 60,
    this.fontSize = 16,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  final String label;

  final VoidCallback? onPressed;

  final double height;

  final double width;

  final double fontSize;

  final bool isLoading;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isLoading ? Colors.grey : color,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: kTextButtonStyle.copyWith(
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
