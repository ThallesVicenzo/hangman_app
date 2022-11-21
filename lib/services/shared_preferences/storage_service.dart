import 'package:shared_preferences/shared_preferences.dart';

class StorageService<K> {
  static late SharedPreferences _preferences;

  static const _keyNickname = 'nickname';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setNickname(String nickname) async =>
      await _preferences.setString(_keyNickname, nickname);

  static String? getNickname() => _preferences.getString(_keyNickname);
}
