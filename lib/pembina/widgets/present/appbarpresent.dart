// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:ekskul/pembina/widgets/present/select_appbar.dart';
import 'package:ekskul/pembina/widgets/present/search_bar_present.dart';
import 'package:ekskul/constant/color.dart';
import 'package:ekskul/pembina/provider/presenst_provider_class.dart';
import 'package:ekskul/pembina/provider/session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarPresent extends StatefulWidget implements PreferredSizeWidget {
  const AppBarPresent({Key? key}) : super(key: key);

  @override
  State<AppBarPresent> createState() => _AppBarPresentState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarPresentState extends State<AppBarPresent> {
  String idEkstra = "";
  @override
  void initState() {
    super.initState();
    Shared.getIdEkstra().then((value) => setState(() => idEkstra = value));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        if (value.isMultiple) {
          return const SelectAppbar();
        } else {
          if (value.isSearch) {
            return const SearchBarPresent();
          } else {
            return AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    // value.isSearch = true;
                    null;
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Absents",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: bone,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${value.presents.length}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
