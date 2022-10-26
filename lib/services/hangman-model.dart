import 'package:hangman_app/services/network.dart';

const link = 'https://hangman-api.herokuapp.com/hangman';

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

  Future<dynamic> getHint(dynamic gameToken) async {
    HangmanApiService hangmanApiService = HangmanApiService(link);

    var hangmanHint = await hangmanApiService.hangmanHint(
        '$link/hint?token=$gameToken');
    return hangmanHint;
  }

  Future<dynamic> getSolution(dynamic gameToken) async {
    HangmanApiService hangmanApiService = HangmanApiService(link);

    var hangmanSolution = await hangmanApiService.hangmanSolution('$link?token=$gameToken');
    return hangmanSolution;
  }
}
