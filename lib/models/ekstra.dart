// To parse this JSON data, do
//
//     final ekstrakurikuler = ekstrakurikulerFromJson(jsonString);

import 'dart:convert';

// Ekstrakurikuler? ekstrakurikuler;
// List<Ekstrakurikuler> ekstrakurikuler = [];
List<Ekstrakurikuler> ekstrakurikulerFromJson(String str) =>
    List<Ekstrakurikuler>.from(
        json.decode(str).map((x) => Ekstrakurikuler.fromJson(x)));

String ekstrakurikulerToJson(List<Ekstrakurikuler> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ekstrakurikuler {
  Ekstrakurikuler({
    required this.id,
    required this.namaEkstrakurikuler,
    required this.hari,
    required this.jamIn,
    required this.jamOut,
    required this.deskripsi,
    required this.image,
  });

  final int id;
  final String namaEkstrakurikuler;
  final String hari;
  final String jamIn;
  final String jamOut;
  final String deskripsi;
  final String image;

  factory Ekstrakurikuler.fromJson(Map<String, dynamic> json) =>
      Ekstrakurikuler(
        id: json["id"],
        namaEkstrakurikuler: json["nama_ekstra"],
        hari: json["hari"],
        jamIn: json["jamIn"],
        jamOut: json["jamOut"],
        deskripsi: json["deskripsi"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_ekstra": namaEkstrakurikuler,
        "hari": hari,
        "jamIn": jamIn,
        "jamOut": jamOut,
        "deskripsi": deskripsi,
        "image": image,
      };
}
