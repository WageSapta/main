import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/peserta.dart';
import '../provider/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class PembinaFirebase {
  FirebaseAuth fa = FirebaseAuth.instance;
  FirebaseFirestore ff = FirebaseFirestore.instance;

  getUser(String uid) async {
    var user = await ff.collection('users').doc(uid).get();
    Map<String, dynamic> ekstra = await getEkstra(uid);
    List pesertas = await getPesertas(uid);
    await Shared.setIdEkstra(user.get('idEkstra'));
    return [
      // ekstra
      Ekstra.fromFirebase(ekstra),
      // peserta
      pesertaFromFirebase(pesertas),
      // users
      Pembina.fromFirebase(user)
    ];
  }

  createUser(UserCredential userCredential, Map<String, dynamic> map) async {
    await ff.collection('users').doc(userCredential.user!.uid).set(map);
    map['ekstra'] = await getEkstra(userCredential) as Map;
    map['peserta'] = await getPesertas(userCredential.user!.uid) as List<Map>;
    // print(map);
    await ff.collection('users').doc(userCredential.user!.uid).set(map);
    var user = await ff.collection('users').doc(userCredential.user!.uid).get();
    return Pembina.fromFirebase(user);
  }

  // updateUser() async {
  //   await ff.collection('users').doc(data!.id).update(data!.toMap());
  // }

  // deleteUser() async {
  //   await ff.collection('users').doc(data!.id).delete();
  // }

  getPesertas(uid) async {
    var user = await ff.collection('users').doc(uid).get();
    var pesertas = await ff
        .collection('siswas')
        .where('idEkstra', arrayContains: user.get('idEkstra'))
        .get();
    return pesertas.docs.map((e) => e.data()).toList();
  }

  getEkstra(uid) async {
    var user = await ff.collection('users').doc(uid).get();
    var ekstra = await ff
        .collection('ekstrakurikulers')
        .where('id', isEqualTo: user.get('idEkstra'))
        .get();
    return ekstra.docs.first.data();
  }
}
