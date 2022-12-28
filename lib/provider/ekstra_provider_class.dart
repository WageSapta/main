import 'dart:collection';
import 'dart:convert';
import 'package:ekskul/globaldata/global.dart';
import 'package:ekskul/models/ekstra.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/session.dart';
import 'package:ekskul/provider/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EkstraProviderClass extends ChangeNotifier {
  List<Ekstrakurikuler> _ekstrakurikuler = [];
  List _listekstra = <Map>[];
  bool _loading = false;
  int _current = 0;
  int? get current => _current;
  bool get loading => _loading;
  List get listEkstra => _listekstra;
  UnmodifiableListView<Ekstrakurikuler> get ekstrakurikulers =>
      UnmodifiableListView(_ekstrakurikuler);

  void setCurrent(int index) {
    _current = index;
    notifyListeners();
  }

  Future ekstra() async {
    try {
      final res = await http.get(Uri.parse(Api.urlEkstrakurikulers));
      List data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _listekstra = data.map((e) => e).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Server Has Problem");
    }
  }

  getEkstrakurikulers() async {
    _loading = true;
    notifyListeners();
    try {
      var token = await Shared.getToken();
      final res = await http.get(Uri.parse(Api.urlEkstra), headers: {
        // 'Content-Type': 'multipart/form-control',
        'Accept': '/*/',
        'Authorization': 'Bearer $token',
      });
      List<Ekstrakurikuler> data =
          ekstrakurikulerFromJson(jsonEncode(jsonDecode(res.body)['data']));
      if (res.statusCode == 200) {
        _ekstrakurikuler = data.map((e) => e).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Server Has Problem");
    }
    _loading = false;
    notifyListeners();
  }
}
