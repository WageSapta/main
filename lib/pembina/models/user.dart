import 'package:cloud_firestore/cloud_firestore.dart';

class Pembina {
  Pembina({
    required this.id,
    required this.idEkstra,
    required this.nama,
    required this.email,
    required this.image,
    required this.peserta,
  });

  final String id;
  final String idEkstra;
  final String nama;
  final String email;
  final String image;
  final List<String> peserta;

  factory Pembina.fromFirebase(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Pembina(
      id: doc.id,
      idEkstra: doc.data()!['idEkstra'],
      nama: doc.data()!['nama'],
      email: doc.data()!['email'],
      image: doc.data()!['image'],
      peserta: List<String>.from(doc.data()!['peserta'].map((e) => e)),
    );
  }
  Map<String, dynamic> toMap() => {
        "idEkstra": idEkstra,
        "nama": nama,
        "email": email,
        "image": image,
        "peserta": peserta.map((e) => e).toList(),
      };
}

class Ekstra {
  Ekstra({
    required this.id,
    required this.nama,
    required this.hari,
    required this.jam,
    required this.deskripsi,
    required this.image,
  });

  final String id;
  final String nama;
  final String hari;
  final String jam;
  final String deskripsi;
  final String image;

  factory Ekstra.fromFirebase(Map<String, dynamic> data) => Ekstra(
        id: data['id'],
        nama: data["nama"],
        hari: data["hari"],
        jam: data["jam"],
        deskripsi: data["deskripsi"],
        image: data["image"],
      );

  Map<String, dynamic> toMap() => {
        "nama": nama,
        "hari": hari,
        "jam": jam,
        "deskripsi": deskripsi,
        "image": image,
      };
}

// class Dokumentasi {
//   Dokumentasi({
//     required this.id,
//     required this.idEkstra,
//     required this.image,
//     required this.tanggal,
//   });

//   final int id;
//   final int idEkstra;
//   final String image;
//   final DateTime tanggal;

//   factory Dokumentasi.fromJson(Map<String, dynamic> json) => Dokumentasi(
//         id: json["id"],
//         idEkstra: json["id_ekstra"],
//         image: json["image"],
//         tanggal: DateTime.parse(json["tanggal"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "id_ekstra": idEkstra,
//         "image": image,
//         "tanggal":
//             "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
//       };
// }


