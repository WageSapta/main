import 'package:ekskul/globaldata/global.dart';
import 'package:ekskul/pages/pengaturan/profile.dart';
import 'package:ekskul/provider/announcement_provider.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:ekskul/widgets/dashboard/list_announcements.dart';
import 'package:ekskul/widgets/dashboard/list_ekstrakurikulers.dart';
import 'package:ekskul/widgets/dashboard/list_kategori.dart';
import 'package:provider/provider.dart';
import '../constant/color.dart';
import 'package:flutter/material.dart';
import '../provider/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  double? lokasi;

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    Provider.of<EkstraProviderClass>(context, listen: false)
        .getEkstrakurikulers();
    Provider.of<AnnouncementsProviderClass>(context, listen: false)
        .getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Consumer<UserProviderClass>(
          builder: (_, data, __) {
            var user = data.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 110,
                          decoration: const BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 5, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  height: 90,
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Image.asset(
                                      'assets/images/logo2.png',
                                      fit: BoxFit.cover,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await push(
                                      context,
                                      const Profile(),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                      color: primary.withOpacity(.1),
                                      image: user!.image.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                Api.urlImage + user.image,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: user.image == ""
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const ListEkstrakurikulers(),
                        ],
                      ),
                    ],
                  ),
                  const ListKategori(),
                  const ListAnnouncements()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
