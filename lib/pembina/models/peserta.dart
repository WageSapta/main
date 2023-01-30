List<Peserta> pesertaFromFirebase(List str) =>
    List<Peserta>.from(str.map((x) => Peserta.fromFirebase(x)));

List pesertaToFirebase(List<Peserta> data) =>
    List<dynamic>.from(data.map((x) => x.toMap()));

class Peserta {
  Peserta({
    required this.idEkstra,
    required this.umur,
    required this.nama,
    required this.kelas,
    required this.nis,
    required this.jenisKelamin,
    required this.jurusan,
    this.id,
  });

  List<String> idEkstra = [];
  final String umur;
  final String nama;
  final String kelas;
  final String nis;
  final String jenisKelamin;
  final String jurusan;
  String? id;

  factory Peserta.fromFirebase(Map<String, dynamic> json) => Peserta(
        idEkstra: List<String>.from(json["idEkstra"].map((x) => x)),
        umur: json["umur"],
        nama: json["nama"],
        kelas: json["kelas"],
        nis: json["nis"],
        jenisKelamin: json["jenisKelamin"],
        jurusan: json["jurusan"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "idEkstra": List<dynamic>.from(idEkstra.map((x) => x)),
        "umur": umur,
        "nama": nama,
        "kelas": kelas,
        "nis": nis,
        "jenisKelamin": jenisKelamin,
        "jurusan": jurusan,
        "id": id,
      };
}
