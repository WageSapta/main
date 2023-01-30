import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'session.dart';
import 'services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EkstraProviderClass extends ChangeNotifier {
  FirebaseFirestore ff = FirebaseFirestore.instance;
  Reference fs = FirebaseStorage.instance.ref();
  final List<Ekstra> _ekstrakurikuler = [];
  List _listekstra = <Map>[];
  bool _loading = false;
  int _current = 0;
  int? get current => _current;
  bool get loading => _loading;
  List get listEkstra => _listekstra;
  List<Ekstra> get ekstrakurikulers => _ekstrakurikuler;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

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
      rethrow;
    }
  }

  getEkstrakurikulers() async {
    loading = true;
    try {
      ekstrakurikulers.clear();
      ff
          .collection('ekstrakurikulers')
          .get()
          .then((value) => value.docs
              .map((e) => ekstrakurikulers.add(Ekstra.fromFirebase(e.data())))
              .toList())
          .whenComplete(() => loading = false);
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
