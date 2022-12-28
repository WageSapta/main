import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static String loginSave = "isLogin";
  static String idUser = "id";
  static String idEkstra = "idEkstra";
  static String tokenUser = "token";
  static Future<bool> saveLoginSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loginSave, true);
  }

  static Future getUserSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(loginSave);
  }

  static Future<bool> deleteUserSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(loginSave, false);
  }

  static setId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(idUser, id);
  }

  static Future<String> getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(idUser)!;
  }

  static setIdEkstra(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(idEkstra, id);
  }

  static Future<String> getIdEkstra() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(idEkstra)!;
  }

  static setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(tokenUser, token);
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenUser)!;
  }
}
