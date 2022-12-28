import 'dart:convert';

HistoryPresentsModel? history;
HistoryPresentsModel historyPresentsModelFromJson(String str) =>
    HistoryPresentsModel.fromJson(jsonDecode(str));

String historyPresentsModelToJson(HistoryPresentsModel data) =>
    json.encode(data.toJson());

class HistoryPresentsModel {
  int total;
  List<HistoryPresent> data;
  HistoryPresentsModel({
    required this.total,
    required this.data,
  });

  factory HistoryPresentsModel.fromJson(Map<String, dynamic> json) {
    return HistoryPresentsModel(
      total: json['total'],
      data: List<HistoryPresent>.from(
          json["data"].map((x) => HistoryPresent.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() => {
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HistoryPresent {
  HistoryPresent({
    required this.idAbsen,
    required this.idSiswa,
    required this.idEkstra,
    required this.nama,
    required this.kelas,
    required this.jurusan,
    required this.jenisAbsen,
    required this.tanggal,
    required this.jam,
  });

  final int idAbsen;
  final int idSiswa;
  final int idEkstra;
  final String nama;
  final String kelas;
  final String jurusan;

  final String jenisAbsen;
  final String tanggal;
  final String jam;

  factory HistoryPresent.fromJson(Map<String, dynamic> json) => HistoryPresent(
        idAbsen: json["id_absen"],
        idSiswa: json["id_siswa"],
        idEkstra: json["id_ekstra"],
        nama: json["nama"],
        kelas: json["kelas"],
        jurusan: json["jurusan"],
        jenisAbsen: json["jenis_absen"],
        tanggal: json["tanggal"],
        jam: json["jam"],
      );

  Map<String, dynamic> toJson() => {
        "id_absen": idAbsen,
        "id_siswa": idSiswa,
        "id_ekstra": idEkstra,
        "nama": nama,
        "kelas": kelas,
        "jurusan": jurusan,
        "jenis_absen": jenisAbsen,
        "tanggal": tanggal,
        "jam": jam
      };
}
