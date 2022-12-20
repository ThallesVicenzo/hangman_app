import 'package:flutter/material.dart';

const kHangmanGallow = 'assets/images/gallow.png';
const kLogout = 'assets/images/out.png';

const kBackgroundColor = Color(0xff421b9c);

const kTextButtonStyle = TextStyle(
  fontFamily: 'PatrickHand',
  color: Colors.white,
  fontSize: 25,
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: kTextButtonStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
    borderSide: BorderSide(color: Colors.red, width: 3.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
