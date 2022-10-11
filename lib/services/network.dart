import 'package:http/http.dart' as http;
import 'dart:convert';


class HangmanApiService {
  HangmanApiService(this.url);
  final String url;

  Future hangmanRequest(String url) async {
    http.Response response = await http.post(Uri.parse(url));
      try {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          return data;
        } else {
          print(response.statusCode);
        }
      } catch(e){
        print(e);
      }
    }
  }