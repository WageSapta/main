import 'dart:convert';
import 'package:ekskul/globaldata/global.dart';
import 'package:ekskul/models/present.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/navbar.dart';
import 'package:ekskul/provider/announcement_provider.dart';
import 'package:ekskul/provider/auth_provider_class.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/presenst_provider_class.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'provider/session.dart';
import 'pages/signpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // void setShared(Response res) async {
  //   await Shared.setIdEkstra(jsonDecode(res.body)['data']['id_ekstra']);
  //   await Shared.setIdEkstra(jsonDecode(res.body)['data']['id_ekstra']);
  // }

  void getAllData(BuildContext context) async {
    var userProvider = context.read<UserProviderClass>();
    var ekstraProvider = context.read<EkstraProviderClass>();
    var announcementsProvider = context.read<AnnouncementsProviderClass>();
    var presentsProvider = context.read<PresentsProviderClass>();
    context
        .read<AuthProviderClass>()
        .getData(id: await Shared.getId(), token: await Shared.getToken())
        .then(
      (val) {
        if (val.statusCode == 200) {
          // get user
          userProvider
              .setUser(userFromJson(jsonEncode(jsonDecode(val.body)['data'])));
          // get ekstrakurikulers
          ekstraProvider.getEkstrakurikulers();
          // get pengumuman
          announcementsProvider.getAnnouncements();
          // set peserta ke variabel siswa
          presentsProvider.siswa.addAll(userProvider.user!.ekstra.peserta);
          // set bool=false untuk multiple select
          presentsProvider.selectedColors.addAll(
              List.filled(userProvider.user!.ekstra.peserta.length, false));
          // get absens
          presentsProvider.getPresents();
          pushreplacement(context, const Navbar());
        } else {
          return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Server Has Problem"),
              margin: EdgeInsets.all(15),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black,
            ),
          );
        }
      },
    );
  }

  void checkUserLoginState(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      await Shared.getUserSharedPreferences().then((value) async {
        if (value == true) {
          getAllData(context);
        } else {
          pushreplacement(context, const SignPage());
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EkstraProviderClass>().ekstra();
      checkUserLoginState(context);
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
