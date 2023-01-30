import 'dart:async';
import 'pembina/firebasemethod/pembina.dart';
import 'pembina/globalwidget/global.dart';
import 'pembina/pages/navbar.dart';
import 'pembina/provider/ekstra_provider_class.dart';
import 'pembina/provider/pembina_provider_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'signpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // void getAllData(BuildContext context) async {
  //   var authProvider = context.read<AuthProviderClass>();
  //   var ekstraProvider = context.read<EkstraProviderClass>();
  //   var announcementsProvider = context.read<AnnouncementsProviderClass>();
  //   Method()
  //       .getData(id: await Shared.getId(), token: await Shared.getToken())
  //       .then(
  //     (val) {
  //       if (val.statusCode == 200) {
  //         // get user
  //         authProvider.user =
  //             userFromJson(jsonEncode(jsonDecode(val.body)['data']));
  //         // get ekstrakurikulers
  //         ekstraProvider.getEkstrakurikulers();
  //         // get pengumuman
  //         announcementsProvider.getAnnouncements();
  //         // get absens
  //         pushreplacement(context, const Navbar());
  //       }
  //     },
  //   ).catchError((e) {
  //     toast("Something is wrong");
  //   });
  // }

  void checkUserLoginState() {
    Timer(const Duration(seconds: 2), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<EkstraProviderClass>(context, listen: false)
            .getEkstrakurikulers();
        PembinaFirebase().getUser(user.uid).then((e) {
          Provider.of<UserProviderClass>(context, listen: false).ekstra = e[0];
          Provider.of<UserProviderClass>(context, listen: false).peserta = e[1];
          Provider.of<UserProviderClass>(context, listen: false).pembina = e[2];
          pushreplacement(context, const Navbar());
        });
      } else {
        pushreplacement(context, const SignPage());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkUserLoginState();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return Material(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "assets/images/logo2.png",
          scale: 4,
        ),
      ),
    );
  }
}
