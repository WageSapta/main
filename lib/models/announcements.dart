// To parse this JSON data, do
//
//     final announcements = announcementsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Announcements> announcementsFromJson(String str) =>
    List<Announcements>.from(
        json.decode(str).map((x) => Announcements.fromJson(x)));

String announcementsToJson(List<Announcements> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcements {
  Announcements({
    required this.id,
    required this.image,
    required this.judul,
    required this.keterangan,
    required this.tanggal,
  });

  int id;
  String image;
  String judul;
  String keterangan;
  DateTime? tanggal;

  factory Announcements.fromJson(Map<String, dynamic> json) {
    return Announcements(
      id: json["id"],
      image: json["image"],
      judul: json["judul"],
      keterangan: json["keterangan"],
      tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "judul": judul,
        "keterangan": keterangan,
        "tanggal": tanggal == null
            ? null
            : "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
      };
}
