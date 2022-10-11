import 'package:hangman_app/services/network.dart';

const link = 'https://hangman-api.herokuapp.com/hangman';


class HangmanModel{
  Future<dynamic> createGame() async {
    var url = link;
    HangmanApiService hangmanApiService = HangmanApiService(url);

    var hangmanData = await hangmanApiService.hangmanRequest(url);
    return hangmanData;
  }
}
