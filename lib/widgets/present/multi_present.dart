import 'package:ekskul/constant/color.dart';
import 'package:ekskul/provider/presenst_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MultiPresents extends StatefulWidget {
  const MultiPresents({Key? key}) : super(key: key);

  @override
  State<MultiPresents> createState() => _MultiPresentsState();
}

class _MultiPresentsState extends State<MultiPresents> {
  int? code;
  FToast? fToast;
  Map<String, List> data = {
    "titles": ["Alpha", "Izin", "Hadir"],
    "colors": [Colors.red[900], Colors.amber[600], Colors.green[800]],
    "routes": []
  };

  @override
  void initState() {
    fToast = FToast();
    FToast().init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, top: 5, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Siswa Select (${value.selectedPresents.length})',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  value.loading
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: primary,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  data['titles']!.length,
                  (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 40),
                            primary: data['colors']![index] as Color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(data['titles']![index]),
                          onPressed: () async {
                            for (var i = 0;
                                i < value.selectedPresents.length;
                                i++) {
                              code = await value.postPresents(
                                idEkstra: value.selectedPresents[i].idEkstra
                                    .toString(),
                                idSiswa:
                                    value.selectedPresents[i].id.toString(),
                                jenisAbsen: data['titles']![index]
                                    .toString()
                                    .toLowerCase(),
                                tanggal: DateFormat('y-M-d')
                                    .format(DateTime.now().toLocal()),
                              );
                            }
                            Navigator.pop(context);
                            if (value.selectedColors.contains(true)) {
                              for (var i = 0;
                                  i < value.selectedPresents.length;
                                  i++) {
                                value.selectedColors[i] = false;
                              }
                              value.selectedPresents.clear();
                            }
                            value.select = false;
                            value.getPresents();

                            if (code == 200) {
                              fToast!.showToast(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Absen ${value.selectedPresents.length} Siswa Success',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                            } else {
                              fToast!.showToast(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Have Problems',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 2),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
