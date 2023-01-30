// To parse this JSON data, do
//
//     final absen = absenFromJson(jsonString);

import 'dart:convert';

// Absen? absen;
List<Present> presentFromJson(String str) =>
    List<Present>.from(json.decode(str).map((x) => Present.fromJson(x)));

String presentToJson(List<Present> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Present {
  Present({
    required this.id,
    required this.idSiswa,
    required this.idEkstra,
    required this.jenisAbsen,
    required this.tanggal,
  });

  final int id;
  final int idSiswa;
  final int idEkstra;
  final String jenisAbsen;
  final String tanggal;

  factory Present.fromJson(Map<String, dynamic> json) {
    return Present(
      id: json["id"],
      idSiswa: json["id_siswa"],
      idEkstra: json["id_ekstra"],
      jenisAbsen: json["jenis_absen"],
      tanggal: json["tanggal"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_siswa": idSiswa,
        "id_ekstra": idEkstra,
        "jenis_absen": jenisAbsen,
        "tanggal": tanggal,
      };
}
