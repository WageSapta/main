import 'dart:convert';
import 'services.dart';
import 'package:http/http.dart' as http;
import 'session.dart';

class Method {
  Future<http.Response> getData({
    required String id,
    required String token,
  }) async {
    try {
      final res =
          await http.get(Uri.parse("${Api.urlAuth}/data/$id"), headers: {
        'Authorization': 'Bearer $token',
      });
      Shared.saveLoginSharedPreferences();
      Shared.setId(id);
      Shared.setIdEkstra(jsonDecode(res.body)['data']['id_ekstra'].toString());
      Shared.setToken(token);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  // members

}
