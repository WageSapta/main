import '../globalwidget/global.dart';
import '../provider/session.dart';
import 'pengaturan/profile.dart';
import 'pengaturan/assignment.dart';
import 'pengaturan/notifications.dart';
import '../../signpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/constant/color.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final list = {
    "name": <String>[
      "Profile",
      "Assignments Recap",
      "Notifications",
      "Privacy policy",
    ],
    "icons": <IconData>[
      Icons.person,
      Icons.assignment,
      Icons.notifications_rounded,
      Icons.privacy_tip_rounded
    ],
    "colors": <Color>[
      const Color.fromARGB(255, 25, 134, 224),
      const Color.fromARGB(255, 255, 200, 0),
      const Color.fromARGB(255, 217, 160, 84),
      const Color.fromRGBO(109, 136, 145, 100),
    ],
    "navigators": <Widget>[],
  };

  logout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctxt) {
        return AlertDialog(
          title: const Text(
            "LOGOUT",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Are you sure to logout?"),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fixedSize: const Size(double.infinity, 40),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fixedSize: const Size(double.infinity, 40),
                      ),
                      child: const Text("Logout"),
                      onPressed: () {
                        FirebaseAuth.instance
                            .signOut()
                            .then(
                              (value) => Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const SignPage(),
                                ),
                                (route) => false,
                              ),
                            )
                            .catchError((e) => EasyLoading.showToast(e));
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    list['navigators'] = [
      const Profile(),
      const Assignments(),
      const Notifications(),
      Container(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<PresentsProviderClass>(context).siswa =
    //     Provider.of<UserProviderClass>(context).user!.ekstra.peserta;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: list['name']!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  onTap: () {
                    push(context, list['navigators']![index] as Widget);
                    // print(list['navigators']![index]);
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        (list['colors']![index] as Color).withOpacity(.1),
                    child: Icon(
                      list['icons']![index] as IconData,
                      color: list['colors']![index] as Color,
                    ),
                  ),
                  title: Text(
                    list['name']![index].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  trailing: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: bone,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Others",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              onTap: () {
                logout(context);
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundColor:
                    const Color.fromARGB(255, 203, 41, 81).withOpacity(.1),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color.fromARGB(255, 203, 41, 81),
                ),
              ),
              title: const Text(
                "Logout",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              trailing: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: bone,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //       primary: Colors.white,
          //       onPrimary: Colors.red,
          //       shadowColor: bone,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(15)),
          //       maximumSize: Size(MediaQuery.of(context).size.width, 70),
          //       minimumSize: Size(MediaQuery.of(context).size.width - 25, 55)),
          //   onPressed: () {
          //     logout(context);
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 15.0),
          //     child: Text(
          //       'Logout',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Color.fromARGB(255, 203, 41, 81),
          //       ),
          //     ),
          //   ),
          // ),
          const Spacer(),
          const Text(
            'v0.5.0',
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
