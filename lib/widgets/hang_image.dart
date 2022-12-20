import 'package:flutter/material.dart';

Widget HangImage(bool visible, String path) {
  return Visibility(
    visible: visible,
      child: Container(
    width: 250,
    height: 250,
    child: Image.asset(path),
  ));
}
