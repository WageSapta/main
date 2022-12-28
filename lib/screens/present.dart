import 'package:ekskul/constant/color.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/presenst_provider_class.dart';
import 'package:ekskul/widgets/present/dialog_siswa.dart';
import 'package:ekskul/widgets/present/multi_present.dart';
import 'package:ekskul/widgets/present/select_siswa.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Presents extends StatefulWidget {
  const Presents({Key? key}) : super(key: key);

  @override
  State<Presents> createState() => _PresentsState();
}

class _PresentsState extends State<Presents> {
  Map dataPresents = {
    "status": ["Alpha", "Izin", "Hadir"],
    "nameButton": ["A", "I", "H"],
    "colors": [
      const Color.fromARGB(255, 222, 30, 16),
      background,
      Colors.green
    ],
  };

  @override
  void initState() {
    super.initState();
    FToast().init(context);
  }

  @override
  Widget build(BuildContext context) {
    var present = Provider.of<PresentsProviderClass>(context, listen: false);
    present.selectedPresents.clear();
    for (var i = 0; i < present.presents.length; i++) {
      present.select = false;
      present.selectedColors[i] = false;
    }
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        value.presents.sort((a, b) => a.nama.compareTo(b.nama));
        return RefreshIndicator(
          onRefresh: value.refreshData,
          backgroundColor: primary,
          child: Scaffold(
            floatingActionButton: value.select == true
                ? FloatingActionButton.extended(
                    label: const Text('Present'),
                    onPressed: () {
                      value.select = false;
                      value.selectedPresents.isEmpty
                          ? FToast().showToast(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Choose Absent',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: const Duration(seconds: 2),
                            )
                          : showModalBottomSheet(
                              context: context, 
                              builder: (BuildContext context) {
                                return const MultiPresents();
                              },
                            );
                    },
                    backgroundColor: primary,
                  )
                : null,
            appBar: value.select == true
                ? selectedAppbar(value)
                : AppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          value.getPresents();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          size: 20.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          value.select = true;
                        },
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.checklist_rtl,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                    title: const Text(
                      "Present",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
            body: value.presents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                            'assets/images/empty.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "Wait after 1 weak",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: value.presents.length,
                    itemBuilder: (context, index) {
                      Peserta present = value.presents[index];
                      return SelectSiswa(
                        index: index,
                        selected: value.selectedColors[index],
                        siswa: present,
                        onTap: () {
                          if (value.select) {
                            value.selectSiswa(
                              selectSiswa: present,
                              condition: "select",
                              i: index,
                            );
                          } else {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogSiswa(siswa: present);
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  AppBar selectedAppbar(PresentsProviderClass value) {
    return AppBar(
      leadingWidth: 80,
      backgroundColor: primary.withOpacity(.1),
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {
              if (value.selectedColors.contains(true)) {
                for (var i = 0; i < value.siswa.length; i++) {
                  value.selectedColors[i] = false;
                }
              }
              value.select = false;
            },
            splashRadius: 20,
            icon: const Icon(
              Icons.close,
              size: 20.0,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            value.selectedPresents.length.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                value.selectSiswa(condition: "all");
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.done_all,
                size: 20.0,
              ),
            ),
            IconButton(
              onPressed: () {
                value.selectSiswa(condition: "clear");
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.remove_done,
                size: 20.0,
              ),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ],
    );
  }
}
