import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '/constant/color.dart';
import '../../models/peserta.dart';
import '../../provider/presenst_provider_class.dart';

class MultipleSelect extends StatefulWidget {
  const MultipleSelect({Key? key}) : super(key: key);

  @override
  State<MultipleSelect> createState() => _MultipleSelectState();
}

class _MultipleSelectState extends State<MultipleSelect> {
  showAll(List<Peserta> data) => data
      .map((item) => DropdownMenuItem(
            value: item.id,
            enabled: false,
            child: Text(
              item.nama,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, top: 5, right: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Students (${value.selectedPresents.length})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      value.loading
                          ? const Padding(
                              padding: EdgeInsets.all(9.0),
                              child: SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: primary,
                                ),
                              ),
                            )
                          : IconButton(
                              splashRadius: 25,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                DropdownButtonFormField2(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  isExpanded: false,
                  hint: Stack(
                    children: List.generate(
                      value.selectedPresents.length >= 10
                          ? (value.selectedPresents.length -
                              (value.selectedPresents.length - 12))
                          : value.selectedPresents.length,
                      (index) {
                        // print(indx);
                        return Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: index == 0 ? 0 : index * 17),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Text(
                                    value.selectedPresents[index].nama
                                        .substring(0, 1),
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: index == 10,
                              child: const Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "...",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                  ),
                  iconSize: 30,
                  buttonHeight: 60,
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  items: showAll(value.selectedPresents),
                  onChanged: (value) {},
                  scrollbarAlwaysShow: true,
                ),
                const Divider(height: 0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: Row(
                    children: List.generate(
                      ["Alpha", "Izin", "Hadir"].length,
                      (index) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primary,
                                fixedSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(["Alpha", "Izin", "Hadir"][index]),
                              onPressed: () async {
                                Future? cek;
                                var length = value.selectedPresents.length;
                                for (var i = 0; i < length; i++) {
                                  cek = await value.doAbsensi(
                                    idSiswa: value.selectedPresents[i].id!,
                                    absensi: ["Alpha", "Izin", "Hadir"][index],
                                  );
                                }
                                cek!.then((e) {
                                  EasyLoading.showToast('Absent success',
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                  value.getData;
                                }).catchError((e) {
                                  EasyLoading.showToast('Absent failed',
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                });

                                // value.isMultiple = false;
                                // Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
