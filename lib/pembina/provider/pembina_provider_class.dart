import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/peserta.dart';
import '../models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserProviderClass extends ChangeNotifier {
  Pembina? _pembina;
  Ekstra? _ekstra;
  List<Peserta>? _peserta;
  bool _loading = false;
  Pembina get pembina => _pembina!;
  Ekstra get ekstra => _ekstra!;
  List<Peserta> get peserta => _peserta!;
  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  set pembina(Pembina val) {
    _pembina = val;
    notifyListeners();
  }

  set ekstra(Ekstra val) {
    _ekstra = val;
    notifyListeners();
  }

  set peserta(List<Peserta> val) {
    _peserta = val;
    notifyListeners();
  }

  Future updateUser(id, name) async {
    loading = true;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'nama': name}).then((_) async {
        var data =
            await FirebaseFirestore.instance.collection('users').doc(id).get();
        pembina = Pembina(
          id: id,
          idEkstra: data.data()!['idEkstra'],
          nama: data.data()!['nama'],
          email: data.data()!['email'],
          image: data.data()!['nama'],
          peserta: data.data()!['peserta'],
        );
        notifyListeners();
      });
      loading = false;
      return "Update user success";
    } catch (_) {
      loading = false;
      throw "Something is wrong";
    }
  }
}
