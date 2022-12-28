import 'package:ekskul/constant/color.dart';
import 'package:ekskul/pages/dashboard/google_map.dart';
import 'package:ekskul/pages/dashboard/history_absensi.dart';
import 'package:ekskul/pages/dashboard/nilai.dart';
import 'package:ekskul/pages/pengaturan/members.dart';
import 'package:flutter/material.dart';


class ListKategori extends StatefulWidget {
  const ListKategori({
    Key? key,
  }) : super(key: key);

  @override
  State<ListKategori> createState() => _ListKategoriState();
}

class _ListKategoriState extends State<ListKategori> {
  Map kategori = {
    "labels": [
      "Members",
      "History",
      "School",
      "Score",
    ],
    "icons": <IconData>[
      Icons.group_rounded,
      Icons.assignment_turned_in_rounded,
      Icons.location_on,
      Icons.create_rounded,
    ],
    "navigators": [
      const Members(),
      const History(),
      const GMap(),
      const Nilai()
    ],
    "data": [5, "0", "0.1 KM", "0"]
  };
  final List<String> images = [
    'assets/announcement/pengumuman1.jpeg',
    'assets/announcement/pengumuman1.jpeg',
    'assets/announcement/pengumuman1.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              // padding: const EdgeInsets.only(left: 15),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: kategori['labels'].length,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(.2),
                              blurRadius: 7,
                              spreadRadius: 4,
                              offset: const Offset(5, 1),
                            )
                          ],
                        ),
                        child: Icon(
                          kategori['icons'][i] as IconData,
                          color: primary,
                        ),
                      ),
                    ),
                    Text(
                      kategori['labels'][i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
