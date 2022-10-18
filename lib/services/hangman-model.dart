import 'package:hangman_app/services/network.dart';

const link = 'https://hangman-api.herokuapp.com/hangman';

/*var httpsUri = Uri(
    scheme: 'https',
    host: 'https://hangman-api.herokuapp.com',
    path: '/hangman',
    queryParameters: {'token': '$', 'letter': ''});*/


class HangmanModel {
  Future<dynamic> createGame() async {
    HangmanApiService hangmanApiService = HangmanApiService(link);

    var hangmanData = await hangmanApiService.hangmanRequest(link);
    return hangmanData;
  }

  Future<dynamic> guessLetter(dynamic gameToken, dynamic letter) async {
    HangmanApiService hangmanApiService = HangmanApiService(link);

    var hangmanLetter = await hangmanApiService.hangmanLetter(
        '$link?token=$gameToken&letter=$letter');
    return hangmanLetter;
  }
}
