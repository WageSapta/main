import 'package:ekskul/models/present.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/services.dart';
import 'package:ekskul/provider/session.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PresentsProviderClass extends ChangeNotifier {
  bool _select = false;
  bool _loading = false;
  List<Peserta> _siswa = [];
  final List<Peserta> _presents = [];
  final List<Peserta> _selectedPresents = [];
  final List<bool> _selectedColors = [];
  bool get select => _select;
  bool get loading => _loading;
  List<Peserta> get siswa => _siswa;
  List<Peserta> get presents => _presents;
  List<Peserta> get selectedPresents => _selectedPresents;
  List<bool> get selectedColors => _selectedColors;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  set siswa(List<Peserta> val) {
    _siswa = val;
    notifyListeners();
  }

  set select(bool val) {
    _select = val;
    notifyListeners();
  }

  Future refreshData() async {
    var id = await Shared.getId();
    var token = await Shared.getToken();
    http.Response res =
        await http.get(Uri.parse("${Api.urlAuth}/data/$id"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    List convert = jsonDecode(res.body)['data']['ekstra']['peserta'];
    List<Peserta> presents =
        List<Peserta>.from(convert.map((x) => Peserta.fromJson(x)));
    print(presents);
    return presents;
  }

  void selectSiswa({Peserta? selectSiswa, String? condition, int? i}) {
    if (condition == "select") {
      if (_selectedPresents.contains(selectSiswa)) {
        _selectedColors[i!] = false;
        _selectedPresents.remove(selectSiswa);
      } else {
        _selectedColors[i!] = true;
        _selectedPresents.add(selectSiswa!);
      }
    }
    if (condition == "all") {
      for (var i = 0; i < _presents.length; i++) {
        if (!_selectedPresents.contains(_presents[i])) {
          _selectedPresents.add(_presents[i]);
          _selectedColors[i] = true;
        }
      }
    }
    if (condition == "clear") {
      for (var i = 0; i < _presents.length; i++) {
        _selectedColors[i] = false;
      }
      _selectedPresents.clear();
    }
    notifyListeners();
  }

  postPresents(
      {required String idEkstra,
      required String idSiswa,
      required String jenisAbsen,
      required String tanggal}) async {
    loading = true;
    try {
      var token = await Shared.getToken();
      var res = await http.post(Uri.parse(Api.urlAbsen), headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'id_ekstra': idEkstra,
        'id_siswa': idSiswa,
        'jenis_absen': jenisAbsen.toLowerCase(),
        'tanggal': tanggal,
      });
      return res.statusCode;
    } catch (e) {
      debugPrint(e.toString());
    }
    loading = false;
  }

  getPresents() async {
    loading = true;
    var idEkstra = await Shared.getIdEkstra();
    try {
      var token = await Shared.getToken();
      var res = await http
          .get(Uri.parse("${Api.urlAbsen}/ekstra/$idEkstra"), headers: {
        'Authorization': 'Bearer $token',
      });
      if (res.statusCode == 200) {
        List<Present> data =
            presentFromJson(jsonEncode(jsonDecode(res.body)['data']));
        var date = DateFormat('y-M-d').format(DateTime.now().toLocal());
        // presents.clear();
        // presents.addAll(siswa);
        // var day = DateTime.now().add( Duration(days: 7));
        // Timer.periodic(Duration(seconds: 3), (t) {
        //   print(t.tick);
        // });
        if (data.isEmpty) {
          for (var j = 0; j < siswa.length; j++) {
            if (!presents.contains(siswa[j])) {
              presents.add(siswa[j]);
            }
          }
        }

        for (var i = 0; i < data.length; i++) {
          for (var j = 0; j < siswa.length; j++) {
            if (date.contains(data[i].tanggal.toString())) {
              if (data[i].idSiswa == siswa[j].id) {
                presents.remove(siswa[j]);
              }
            } else {
              presents.add(siswa[j]);
            }
          }
        }
        // for (var element in cek) {
        //   print(element.nama);
        // }
        print(presents.length);
        // present = presentFromJson(jsonEncode(d));
        // for (var i = 0; i < _siswa.length; i++) {
        //   if (_siswa[i].id == present[i].idSiswa) {
        //     _siswa.removeAt(i);
        //   }
        // }
        // print(data);
        // print(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    loading = false;
  }
}
