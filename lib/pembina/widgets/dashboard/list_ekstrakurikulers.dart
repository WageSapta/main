import 'package:carousel_slider/carousel_slider.dart';
import '../../../constant/color.dart';
import '../../globalwidget/global.dart';
import '../../pages/dashboard/detail_ekstra.dart';
import '../../provider/ekstra_provider_class.dart';
import '../../provider/pembina_provider_class.dart';
import '../shimer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ListEkstrakurikulers extends StatefulWidget {
  const ListEkstrakurikulers({Key? key}) : super(key: key);

  @override
  State<ListEkstrakurikulers> createState() => _ListEkstrakurikulersState();
}

class _ListEkstrakurikulersState extends State<ListEkstrakurikulers> {
  final controller = CarouselController();
  final warna = [
    bone,
    brown.withOpacity(.1),
  ];

  // _showMsg(msg) {
  //   final snackBar = SnackBar(
  //     backgroundColor: Colors.grey[900],
  //     margin: const EdgeInsets.all(15),
  //     behavior: SnackBarBehavior.floating,
  //     duration: const Duration(seconds: 1),
  //     dismissDirection: DismissDirection.down,
  //     elevation: 0,
  //     content: Text(msg),
  //   );
  //   return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProviderClass, EkstraProviderClass>(
        builder: (_, pembina, ekstra, __) {
      var ekstrakurikulers = ekstra.ekstrakurikulers;
      var current = ekstra.current!;
      return Column(
        children: [
          ekstra.loading
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomWidget.rectangular(height: 200),
                )
              : CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: ekstrakurikulers.length,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      ekstra.setCurrent(index);
                    },
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    initialPage: ekstra.current!,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return GestureDetector(
                      onTap: () => ekstrakurikulers[index].id.toString() ==
                              // user.ekstra.id.toString()
                              pembina.pembina.id.toString()
                          ? push(
                              context,
                              DetailsEkstra(
                                ex: ekstrakurikulers[index],
                              ),
                            )
                          : Container(),
                      child: Container(
                        // height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(ekstrakurikulers[index].image),
                          ),
                          color: warna[index % 2],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ekstrakurikulers[index].nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Visibility(
                                    visible: ekstrakurikulers[index].id ==
                                        pembina.ekstra.id,
                                    child: Container(
                                      decoration: const ShapeDecoration(
                                        color: Colors.white,
                                        shape: StadiumBorder(),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(Icons.done),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "view details >",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ekstrakurikulers.asMap().entries.map(
                (entry) {
                  return GestureDetector(
                    onTap: () => controller.animateToPage(entry.key),
                    child: Container(
                      height: current == entry.key ? 9 : 6,
                      width: current == entry.key ? 9 : 6,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : primary
                                .withOpacity(current == entry.key ? 0.6 : 0.2),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      );
    });
  }
}
