import 'package:ekskul/constant/color.dart';
import 'package:ekskul/pembina/provider/presenst_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SelectAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var value = context.watch<PresentsProviderClass>();
    return WillPopScope(
      onWillPop: () {
        value.selectedPresents.clear();
        value.isMultiple = false;
        return Future.value(false);
      },
      child: AppBar(
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            value.selectedPresents.clear();
            value.isMultiple = false;
          },
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          "${value.selectedPresents.length}/${value.presents.length}",
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              value.selectSiswa(condition: "all");
            },
            splashRadius: 20,
            icon: const Icon(Icons.select_all, color: Colors.white),
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            onPressed: () {
              value.selectedPresents.clear();
              value.isMultiple = false;
            },
            splashRadius: 20,
            icon: const Icon(Icons.deselect, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
