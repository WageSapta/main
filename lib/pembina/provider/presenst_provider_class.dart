import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../models/peserta.dart';
import 'session.dart';

class PresentsProviderClass extends ChangeNotifier {
  final fa = FirebaseAuth.instance;
  final ff = FirebaseFirestore.instance;
  bool _isSearch = false;
  bool _isMultiple = false;
  bool _loading = false;
  // Future? _get;
  // List<Peserta> _searchList = [];
  final List<Peserta> _siswa = [];
  final List<Peserta> _presents = [];
  final List<Peserta> _selectedPresents = [];
  Future? _refresh;
  Future? _getData;

  bool get isSearch => _isSearch;
  bool get isMultiple => _isMultiple;
  bool get loading => _loading;
  // List<Peserta> get searchList => _searchList;
  List<Peserta> get siswa => _siswa;
  List<Peserta> get presents => _presents;
  List<Peserta> get selectedPresents => _selectedPresents;
  Future get refresh {
    _refresh = refreshData();
    notifyListeners();
    return _refresh!;
  }

  Future get getData {
    _getData = getPresents();
    notifyListeners();
    return _getData!;
  }

  // set searchList(List<)
  set siswa(val) {
    List<Peserta> data = [];
    data.add(val);
    _siswa.addAll(data);
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

  set isMultiple(bool val) {
    _isMultiple = val;
    notifyListeners();
  }

  Future refreshData() async {
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
        if (siswa.where((element) => element.id == e.data().id).isEmpty) {
          siswa.add(e.data());
        }
      }
    } catch (_) {
      rethrow;
    }
  }

  void selectSiswa({Peserta? selectSiswa, String? condition}) {
    if (condition == "select") {
      if (_selectedPresents.contains(selectSiswa)) {
        _selectedPresents.remove(selectSiswa);
      } else {
        _selectedPresents.add(selectSiswa!);
      }
      if (selectedPresents.isEmpty) {
        isMultiple = false;
      }
    }
    if (condition == "all") {
      if (selectedPresents.length != presents.length) {
        for (var i = 0; i < _presents.length; i++) {
          if (!_selectedPresents.contains(_presents[i])) {
            _selectedPresents.add(_presents[i]);
          }
        }
      }
    }
    notifyListeners();
  }

  getSiswa(int tgl) async {
    String tanggal = DateFormat('yyyy/MM/dd HH:mm')
        .format(DateTime.fromMicrosecondsSinceEpoch(tgl * 1000));
    String dateNow =
        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now().toLocal());
    try {
      var idEkstra = await Shared.getIdEkstra();
      await ff
          .collection('siswas')
          .where('idEkstra', arrayContains: idEkstra)
          .orderBy('nama', descending: false)
          .withConverter<Peserta>(
            fromFirestore: (snapshot, _) =>
                Peserta.fromFirebase(snapshot.data()!),
            toFirestore: (model, _) => model.toMap(),
          )
          .get()
          .then((value) {
        for (var e in value.docs) {
          if (tanggal.split(' ')[0] == dateNow.split(' ')[0]) {}
          if (_siswa.where((element) => element.id == e.data().id).isEmpty) {
            _siswa.add(e.data());
          }
        }
      });
    } on Exception catch (_) {
      EasyLoading.showToast("Something went error",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Future doAbsensi({
    required String idSiswa,
    required String absensi,
  }) async {
    loading = true;
    try {
      EasyLoading.show(
        status: "Send absent..",
        indicator: const CircularProgressIndicator(color: Colors.white),
      );
      var idEkstra = await Shared.getIdEkstra();
      var map = {
        'idEkstra': idEkstra,
        'idSiswa': idSiswa,
        'absensi': absensi,
        'tanggal': DateTime.now().toLocal().millisecondsSinceEpoch
      };
      CollectionReference absents = ff.collection('absents');
      absents.add(map).catchError((e) {
        EasyLoading.showToast('Absent failed');
      });
      EasyLoading.dismiss();
    } on Exception catch (_) {
      // print(_);
      EasyLoading.dismiss();
    }
    loading = false;
  }

  // sortirAbsensi(AsyncSnapshot<QuerySnapshot> absents,
  //     AsyncSnapshot<QuerySnapshot> siswas) {
  //   var tanggal = DateFormat('yyyy/MM/dd').format(DateTime.now().toLocal());
  //   String convertTanggal(value) => DateFormat('yyyy/MM/dd').format(
  //       DateTime.fromMicrosecondsSinceEpoch(value.get('tanggal') * 1000));

  //   if (absents.data!.docs.isEmpty) {
  //     _siswa.clear();
  //     List<Peserta> data =
  //         siswas.data!.docs.map((e) => e.data() as Peserta).toList();

  //     _siswa.addAll(data);
  //   } else {
  //     _siswa.clear();
  //     for (var f in absents.data!.docs) {
  //       for (var g in siswas.data!.docs) {
  //         if (f.get('idSiswa') == (g.data() as Peserta).id &&
  //             convertTanggal(f) == tanggal) {
  //           _siswa.removeWhere((t) => t.id == f.get('idSiswa'));
  //         } else {
  //           if (absents.data!.docs
  //               .where((element) =>
  //                   element.get('idSiswa') == (g.data() as Peserta).id)
  //               .isEmpty) {
  //             if (_siswa
  //                 .where((element) => element.id == (g.data() as Peserta).id)
  //                 .isEmpty) {
  //               _siswa.add((g.data() as Peserta));
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  Future getPresents() async {
    loading = true;
    var idEkstra = await Shared.getIdEkstra();
    try {
      selectedPresents.clear();
      await refreshData();
      var absents = await ff
          .collection('absents')
          .where('idEkstra', isEqualTo: idEkstra)
          .get();
      if (absents.docs.isEmpty) {
        for (var e in siswa) {
          if (presents.where((element) => element.id == e.id).isEmpty) {
            presents.add(e);
          }
        }
      } else {
        presents.clear();
        for (var a in absents.docs) {
          for (var s in siswa) {
            if (a.data()['idSiswa'] == s.id) {
              presents.removeWhere((e) => e.id == s.id);
            } else {
              if (absents.docs
                  .where((element) => element.data()['idSiswa'] == s.id)
                  .isEmpty) {
                if (presents.where((e) => e.id == s.id).isEmpty) {
                  presents.add(s);
                }
              }
            }
          }
        }
      }
      loading = false;
      return presents;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
