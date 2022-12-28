import 'dart:convert';
import 'package:ekskul/provider/session.dart';
import 'package:ekskul/provider/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProviderClass extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<http.Response> getData({
    required String id,
    required String token,
  }) async {
    final res = await http.get(Uri.parse("${Api.urlAuth}/data/$id"), headers: {
      'Authorization': 'Bearer $token',
    });
    Shared.saveLoginSharedPreferences();
    Shared.setId(id);
    Shared.setIdEkstra(jsonDecode(res.body)['data']['id_ekstra'].toString());
    Shared.setToken(token);
    return res;
  }

  Future authLogin({
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await http.post(Uri.parse("${Api.urlAuth}/login"),
          body: {"email": email, "password": password});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var res = getData(
          id: data['data']['id'].toString(),
          token: data['access_token'],
        );
        return res;
      } else {
        debugPrint("Login Gagal");
      }
    } catch (e) {
      debugPrint("Server Has Problem");
    }
    _loading = false;
    notifyListeners();
  }
}
