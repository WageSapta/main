import 'package:carousel_slider/carousel_slider.dart';
import 'package:ekskul/provider/announcement_provider.dart';
import 'package:ekskul/widgets/shimer.dart';
import 'package:flutter/material.dart';
import 'package:ekskul/constant/color.dart';
import 'package:ekskul/provider/services.dart';
import 'package:provider/provider.dart';

class ListAnnouncements extends StatelessWidget {
  const ListAnnouncements({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Announcements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<AnnouncementsProviderClass>(
            builder: (context, value, child) {
              var data = value.announcements;
              if (value.loading == true || data == null) {
                return const Padding(
                  padding: EdgeInsets.all(21.0),
                  child: CustomWidget.rectangular(height: 200),
                );
              }
              if (data.isEmpty) {
                return const Center(child: Text('Tidak ada pengumuman'));
              }
              return Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: data.length,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        value.setCurrent(index);
                      },
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.9,
                      initialPage: value.current,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // border: Border.all(color: Colors.white, width: 3),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  Api.urlAnnouncementsImage + data[index].image,
                                ),
                              ),
                              color: bone,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white.withOpacity(.5), white],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data[index].judul,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: data.asMap().entries.map(
                        (entry) {
                          return Container(
                            height: value.current == entry.key ? 9 : 6,
                            width: value.current == entry.key ? 9 : 6,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : primary.withOpacity(
                                      value.current == entry.key ? 0.6 : 0.2),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
