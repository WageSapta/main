import 'package:ekskul/pembina/provider/presenst_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/color.dart';

class SearchBarPresent extends StatelessWidget implements PreferredSizeWidget {
  const SearchBarPresent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        return AppBar(
          backgroundColor: primary,
          leading: IconButton(
            onPressed: () => value.isSearch = false,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: SizedBox(
            height: preferredSize.height,
            width: double.infinity,
            child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  )),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) {
                // value.presents.clear();
                var result = value.presents
                    .where((element) =>
                        element.nama
                            .toLowerCase()
                            .contains(val.toLowerCase()) ||
                        ("${element.kelas} ${element.jurusan}")
                            .toLowerCase()
                            .contains(
                              val.toLowerCase(),
                            ))
                    .toList();
                // for (var e in value.siswa) {
                //   bool validation =
                //       e.nama.toLowerCase().contains(val.toLowerCase()) ||
                //           ("${e.kelas} ${e.jurusan}").toLowerCase().contains(
                //                 val.toLowerCase(),
                //               );

                //   if (validation) {
                //     value.presents.add(e);
                //   }
                // }
                value.presents.clear();
                value.presents.addAll(result);

                print(value.presents.length);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
// Autocomplete<Peserta>(
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text == '') {
//                   return const Iterable<Peserta>.empty();
//                 } else {
//                   List<Peserta> matches = <Peserta>[];
//                   matches.addAll(value.presents);

//                   matches.where((Peserta s) => s
//                       .toString()
//                       .contains(textEditingValue.text.toLowerCase()));
//                   return matches;
//                 }
//               },
//               onSelected: (selection) {
//                 print('You just selected $selection');
//               },
//             ),