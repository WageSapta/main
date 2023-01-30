import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/peserta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'session.dart';

class MembersProviderClass extends ChangeNotifier {
  FirebaseAuth fa = FirebaseAuth.instance;
  FirebaseFirestore ff = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  String _searchResult = "";
  final List<Peserta> _members = [];
  bool _isSearch = false;
  bool _loading = false;

  TextEditingController get searchController => _searchController;
  List<Peserta> get members => _members;
  String get searchResult => _searchResult;
  bool get loading => _loading;
  bool get isSearch => _isSearch;

  set membersLength(int val) {
    membersLength = val;
    notifyListeners();
  }

  set searchResult(String searchResult) {
    _searchResult = searchResult;
    notifyListeners();
  }

  set isSearch(bool val) {
    _isSearch = val;
    notifyListeners();
  }

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future postMember(
      {required String nis,
      required String name,
      required String classs,
      required String major,
      required String age,
      required String gender}) async {
    loading = true;
    var idEkstra = await Shared.getIdEkstra();
    try {
      map({String? id}) {
        return Peserta(
          id: id ?? "0",
          idEkstra: [idEkstra],
          nis: nis,
          nama: name,
          kelas: classs,
          jurusan: major,
          umur: age,
          jenisKelamin: gender,
        );
      }

      var count = await ff
          .collection('siswas')
          .where('idEkstra', arrayContains: idEkstra)
          .where('nis', isEqualTo: nis)
          .get();
      if (count.docs.isEmpty) {
        var cl = ff.collection('siswas');
        cl.add(map().toMap()).then((value) {
          cl.doc(value.id).set(map(id: value.id).toMap());
        });
        return "Add member success";
      } else {
        throw "Nis already exists";
      }
    } catch (_) {
      loading = false;
      rethrow;
    }
  }

  Future updateMember(
      {required String nisCek,
      required String id,
      required String nis,
      required String name,
      required String classs,
      required String major,
      required String age,
      required String gender}) async {
    loading = true;
    var idEkstra = await Shared.getIdEkstra();
    try {
      Peserta map = Peserta(
        id: id,
        idEkstra: [idEkstra],
        nis: nis,
        nama: name,
        kelas: classs,
        jurusan: major,
        umur: age,
        jenisKelamin: gender,
      );

      var count =
          await ff.collection('siswas').where('nis', isEqualTo: nis).get();
      if (count.docs.isEmpty || nis == nisCek) {
        await ff.collection('siswas').doc(id).update(map.toMap());
        return "Update member success";
      } else {
        throw "Nis already exists";
      }
    } catch (_) {
      loading = false;
      rethrow;
    }
  }

  Future refreshData() async {
    try {
      var idEkstra = await Shared.getIdEkstra();
      ff
          .collection('siswas')
          .where('idEkstra', arrayContains: idEkstra)
          .orderBy('nama')
          .withConverter<Peserta>(
            fromFirestore: (snapshot, options) =>
                Peserta.fromFirebase(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .get()
          .then((value) {
        members.clear();
        members.addAll(value.docs.map((e) => e.data()).toList());
        notifyListeners();
      });
    } catch (_) {
      rethrow;
    }
  }

  Future deleteMember(id) async {
    loading = true;
    try {
      ff.collection('siswas').doc(id).delete();
      loading = false;
      return "Delete member success";
    } catch (_) {
      loading = false;
      throw "Something is wrong";
    }
  }

  Future getMembers() async {
    loading = true;
    var idEkstra = await Shared.getIdEkstra();
    try {
      var siswas = await ff
          .collection('siswas')
          .where('idEkstra', arrayContains: idEkstra)
          .orderBy('nama')
          .withConverter<Peserta>(
            fromFirestore: (snapshot, options) =>
                Peserta.fromFirebase(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .get();
      for (var e in siswas.docs) {
        if (members.where((element) => element.id == e.data().id).isEmpty) {
          members.add(e.data());
        }
      }
      loading = false;
      return members;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
