import 'dart:async';
import 'dart:convert';
import 'services.dart';
import 'package:http/http.dart' as http;
import '../models/announcements.dart';
import '../pages/dashboard/detail_pengumuman.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AnnouncementsProviderClass extends ChangeNotifier {
  bool _loading = false;
  int _current = 0;
  List<Announcements>? _announcements;
  bool get loading => _loading;
  int get current => _current;
  List<Announcements>? get announcements => _announcements;
  // final _streamController = BehaviorSubject<List<Announcements>>();
  // List<Announcements>? get announcements => _announcements;
  // BehaviorSubject<List<Announcements>> get announcementsStream =>
  //     _streamController;

  void setCurrent(int index) {
    _current = index;
    notifyListeners();
  }

  Future getAnnouncements() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await http.get(Uri.parse(Api.urlAnnouncements));
      var data = jsonDecode(res.body)['data'];
      if (res.statusCode == 200) {
        var d = announcementsFromJson(jsonEncode(data));
        _announcements = d;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
    _loading = false;
    notifyListeners();
  }
}
