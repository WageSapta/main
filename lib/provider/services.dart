class Api {
  static String endpoint = "localhost";
  // static String endpoint = "127.0.0.1";
  // static String endpoint = '192.168.1.4';
// auth POST{/login}, auth POST{/register}, auth POST{/logout}, auth GET DATA{/data/id}
  static String urlAuth = "http://$endpoint:8000/api/auth";
// absen POST, absen PUT{/id}, absen GET ALL BY ID EKSTRA{/ekstra/(id_ekstra)}, absen GET SINGLE{/id},absen DELETE{/id}
  static String urlAbsen = "http://$endpoint:8000/api/absens";
// ekstra POST, ekstra PUT{/id}, ekstra GET ALL, ekstra GET SINGLE{/id},ekstra DELETE{/id}
  static String urlEkstra = "http://$endpoint:8000/api/ekstras";
// get all ekstrakurikuler{id,nama}
  static String urlEkstrakurikulers =
      "http://$endpoint:8000/api/ekstrakurikulers";
// all, add, search
  static String urlSiswa = "http://$endpoint:8000/api/siswas";
// all
  static String urlAnnouncements = "http://$endpoint:8000/api/announcements";
// image image and dokumentasi
  static String urlImage = "http://$endpoint:8000/storage/images/";
  static String urlDokumentasi = "http://$endpoint:8000/storage/dokumentasi/";
  static String urlAnnouncementsImage =
      "http://$endpoint:8000/storage/announcements/";
}
