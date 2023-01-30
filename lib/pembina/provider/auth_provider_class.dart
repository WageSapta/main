import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebasemethod/pembina.dart';
import '../models/user.dart';
import 'pembina_provider_class.dart';
import 'session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AuthProviderClass extends ChangeNotifier {
  final pembina = UserProviderClass();
  UserCredential? _userCredential;
  final FirebaseAuth fa = FirebaseAuth.instance;
  final FirebaseFirestore ff = FirebaseFirestore.instance;
  // Pembina? _pembina;
  bool _loading = false;
  bool get loading => _loading;
  // Pembina get pembina => _pembina!;
  UserCredential get userCredential => _userCredential!;

  set userCredential(UserCredential val) {
    _userCredential = val;
    notifyListeners();
  }

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future signIn({
    required String email,
    required String password,
  }) async {
    loading = true;
    try {
      userCredential = await fa.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      loading = false;
      return PembinaFirebase().getUser(userCredential.user!.uid);
    } on FirebaseAuthException catch (_) {
      loading = false;
      rethrow;
    }
  }

  Future signUp({
    required String email,
    required String password,
    required String nama,
    required String idEkstra,
  }) async {
    loading = true;
    var ekstra = await ff.collection('users').get();
    try {
      if (ekstra.docs
          .where((element) => element.get('idEkstra') == idEkstra)
          .isNotEmpty) {
        loading = false;
        EasyLoading.showToast(
          'Extracurriculer already exist',
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      } else {
        userCredential = await fa.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var map = {
          'idEkstra': idEkstra,
          'nama': nama,
          'email': email,
          'image': "",
          'ekstra': {},
          'peserta': [],
        };
        await Shared.setIdEkstra(idEkstra);
        loading = false;
        return PembinaFirebase().createUser(userCredential, map);
      }
    } on FirebaseAuthException catch (_) {
      loading = false;
      rethrow;
    }
  }

  Future signOut() async {
    loading = true;
    try {
      await fa.signOut();
      loading = false;
    } on FirebaseAuthException catch (_) {
      loading = false;
      rethrow;
    }
  }

  determineError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Invalid email';
      case 'user-disabled':
        return 'User disabled';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return 'Email already in use';
      case 'invalid-credential':
        return 'Invalid credential';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'weak-password':
        return 'Weak password';
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return 'Error';
    }
  }
}
