import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.color, required this.title, required this.style, @required this.onPressed}) : super(key: key);

  final Color? color;
  final String? title;
  final Function()? onPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Material(
        elevation: 1,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onPressed,
          child: Center(
            child: Text(
              title!,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
