import 'dart:async';
import '../../constant/color.dart';
import '../provider/auth_provider_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({Key? key}) : super(key: key);

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Verification Email"),
        actions: const [],
      ),
      body: Consumer<AuthProviderClass>(
        builder: (context, value, child) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            color: Colors.red,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Verification email has been sent to ${value.fa.currentUser!.email}",
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    maximumSize: Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    try {
                      // value.userCredential.user!.sendEmailVerification();
                      Timer.periodic(Duration(seconds: 30), (timer) {});
                    } catch (e) {
                      EasyLoading.showToast("$e");
                    }
                  },
                  child: Text("Resend"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
