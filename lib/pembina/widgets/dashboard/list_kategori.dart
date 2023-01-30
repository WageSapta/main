import '../../../constant/color.dart';
import '../../globalwidget/global.dart';
import '../../pages/dashboard/google_map.dart';
import 'categories_history.dart';
import '../../pages/dashboard/members.dart';
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
      // "Score",
    ],
    "icons": <IconData>[
      Icons.group_rounded,
      Icons.assignment_turned_in_rounded,
      Icons.location_on,
      // Icons.create_rounded,
    ],
    "navigators": [
      const Members(),
      const History(),
      const GMap(),
      // const Nilai()
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
            height: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: kategori['labels'].length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            push(context, kategori['navigators'][i]);
                          },
                          child: PhysicalModel(
                            elevation: 10.0,
                            color: Colors.white,
                            shadowColor: Colors.black45,
                            shape: BoxShape.circle,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child:
                                    Icon(kategori['icons'][i], color: primary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          kategori['labels'][i],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
