// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

// User? user;
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.idEkstra,
    required this.nama,
    required this.email,
    required this.emailVerifiedAt,
    required this.image,
    required this.ekstra,
  });

  final int id;
  final int idEkstra;
  final String nama;
  final String email;
  final DateTime emailVerifiedAt;
  final String image;
  final Ekstra ekstra;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        idEkstra: json["id_ekstra"],
        nama: json["nama"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"] ?? ""),
        image: json["image"] == null ? "" : json['image'],
        ekstra: Ekstra.fromJson(json["ekstra"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_ekstra": idEkstra,
        "nama": nama,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "image": image,
        "ekstra": ekstra.toJson(),
      };
}

class Ekstra {
  Ekstra({
    required this.id,
    required this.namaEkstra,
    required this.hari,
    required this.jamIn,
    required this.jamOut,
    required this.deskripsi,
    required this.image,
    required this.dokumentasi,
    required this.peserta,
  });

  final int id;
  final String namaEkstra;
  final String hari;
  final String jamIn;
  final String jamOut;
  final String deskripsi;
  final String image;
  final List<Dokumentasi> dokumentasi;
  final List<Peserta> peserta;

  factory Ekstra.fromJson(Map<String, dynamic> json) => Ekstra(
        id: json["id"],
        namaEkstra: json["nama_ekstra"],
        hari: json["hari"],
        jamIn: json["jamIn"],
        jamOut: json["jamOut"],
        deskripsi: json["deskripsi"],
        image: json["image"],
        dokumentasi: List<Dokumentasi>.from(
            json["dokumentasi"].map((x) => Dokumentasi.fromJson(x))),
        peserta:
            List<Peserta>.from(json["peserta"].map((x) => Peserta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_ekstra": namaEkstra,
        "hari": hari,
        "jamIn": jamIn,
        "jamOut": jamOut,
        "deskripsi": deskripsi,
        "image": image,
        "dokumentasi": List<dynamic>.from(dokumentasi.map((x) => x.toJson())),
        "peserta": List<dynamic>.from(peserta.map((x) => x.toJson())),
      };
}

class Dokumentasi {
  Dokumentasi({
    required this.id,
    required this.idEkstra,
    required this.image,
    required this.tanggal,
  });

  final int id;
  final int idEkstra;
  final String image;
  final DateTime tanggal;

  factory Dokumentasi.fromJson(Map<String, dynamic> json) => Dokumentasi(
        id: json["id"],
        idEkstra: json["id_ekstra"],
        image: json["image"],
        tanggal: DateTime.parse(json["tanggal"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_ekstra": idEkstra,
        "image": image,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
      };
}

class Peserta {
  Peserta({
    required this.id,
    required this.idEkstra,
    required this.nisn,
    required this.nama,
    required this.kelas,
    required this.jurusan,
    required this.umur,
    required this.jenisKelamin,
  });

  final int id;
  final int idEkstra;
  final String nisn;
  final String nama;
  final String kelas;
  final String jurusan;
  final String umur;
  final String jenisKelamin;

  factory Peserta.fromJson(Map<String, dynamic> json) => Peserta(
        id: json["id"],
        idEkstra: json["id_ekstra"],
        nisn: json["nisn"],
        nama: json["nama"],
        kelas: json["kelas"],
        jurusan: json["jurusan"],
        umur: json["umur"],
        jenisKelamin: json["jenis_kelamin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_ekstra": idEkstra,
        "nisn": nisn,
        "nama": nama,
        "kelas": kelas,
        "jurusan": jurusan,
        "umur": umur,
        "jenis_kelamin": jenisKelamin,
      };
}
