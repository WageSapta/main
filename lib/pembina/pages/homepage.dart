import '../provider/ekstra_provider_class.dart';
import '../provider/pembina_provider_class.dart';
import '../widgets/dashboard/list_announcements.dart';
import '../widgets/dashboard/list_ekstrakurikulers.dart';
import '../widgets/dashboard/list_kategori.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '/constant/color.dart';
import 'package:flutter/material.dart';

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
    Provider.of<EkstraProviderClass>(context, listen: false)
        .getEkstrakurikulers()
        .catchError((e) => EasyLoading.showToast('Something is wrong'));
    // Provider.of<AnnouncementsProviderClass>(context, listen: false)
    //     .getAnnouncements()
    //     .catchError((e) => toast("Something is wrong"));
  }

  Future get refresh => refreshData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProviderClass>(
        builder: (context, value, child) {
          return RefreshIndicator(
            color: primary,
            onRefresh: () => refresh,
            child: SingleChildScrollView(
              // physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(35),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, right: 20),
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
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    // borderRadius: BorderRadius.circular(15),
                                    // color: primary.withOpacity(.1),
                                    image: value.pembina.image.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                value.pembina.image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: value.pembina.image.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.person,
                                            size: 30,
                                            color: primary,
                                          ),
                                        )
                                      : const SizedBox(),
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
            ),
          );
        },
      ),
    );
  }
}
