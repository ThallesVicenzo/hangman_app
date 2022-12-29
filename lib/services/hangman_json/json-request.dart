import 'dart:convert';
import 'package:flutter/services.dart';

const jsonPath = 'assets/json/names.json';

class HangmanJsonRequest {

  Future<dynamic> loadJson() async {
    String data = await rootBundle.loadString(jsonPath);
    var hangmanData = json.decode(data);
    return hangmanData;
  }
}
