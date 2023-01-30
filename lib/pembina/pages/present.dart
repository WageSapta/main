import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/presenst_provider_class.dart';
import '../provider/session.dart';
import '../widgets/present/appbarpresent.dart';
import '../widgets/present/multiple_select.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '/constant/color.dart';
import '../widgets/present/dialog_siswa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Presents extends StatefulWidget {
  const Presents({Key? key}) : super(key: key);

  @override
  State<Presents> createState() => _PresentsState();
}

class _PresentsState extends State<Presents> {
  final ff = FirebaseFirestore.instance;
  Future? futureGet;
  String idEkstra = "";
  Map dataPresents = {
    "status": ["Alpha", "Izin", "Hadir"],
    "colors": [
      const Color.fromARGB(255, 222, 30, 16),
      background,
      Colors.green
    ],
  };
  String date(QueryDocumentSnapshot value) {
    int tgl = value.get('tanggal');
    String data = DateFormat('yyyy/MM/dd')
        .format(DateTime.fromMicrosecondsSinceEpoch(tgl * 1000));
    return data;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Shared.getIdEkstra().then((value) => setState(() => idEkstra = value));
      futureGet = Provider.of<PresentsProviderClass>(context, listen: false)
          .getPresents();
    });
  }

  @override
  Widget build(BuildContext context) {
    var tanggal = DateFormat('yyyy/MM/dd').format(DateTime.now());
    return Consumer<PresentsProviderClass>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: Visibility(
            visible: value.isMultiple,
            child: FloatingActionButton.extended(
              label: const Text('Absents'),
              onPressed: () => showDialog(
                barrierDismissible: value.loading ? false : true,
                context: context,
                builder: (context) => const MultipleSelect(),
              ),
              backgroundColor: primary,
            ),
          ),
          appBar: const AppBarPresent(),
          body: RefreshIndicator(
            color: primary,
            onRefresh: () => value.getData,
            child: Stack(
              children: [
                ListView(),
                FutureBuilder(
                  future: futureGet,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      EasyLoading.showError(snapshot.error.toString());
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(color: primary),
                        ),
                      );
                    }

                    if (value.presents.isEmpty &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Center(
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
                              "Comeback again until next practice",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return listViewListTile(value);
                    // return listViewListTile(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView listViewListTile(PresentsProviderClass value) {
    return ListView.builder(
      itemCount: value.presents.length,
      itemBuilder: (context, index) {
        var data = value.presents[index];
        String jk = '';
        if (data.jenisKelamin == "L") {
          jk = "Laki Laki";
        } else {
          jk = "Perempuan";
        }
        return Stack(
          children: [
            ListTile(
              key: UniqueKey(),
              dense: true,
              selected: true,
              selectedTileColor: value.selectedPresents.contains(data)
                  ? bone.withOpacity(.3)
                  : Colors.white,
              onLongPress: () {
                value.isMultiple = true;
                value.selectSiswa(selectSiswa: data, condition: 'select');
              },
              onTap: () {
                if (value.isMultiple) {
                  value.selectSiswa(selectSiswa: data, condition: 'select');
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => DialogSiswa(siswa: data),
                  );
                }
              },
              // selected: value.selectedPresents.contains(data),
              leading: CircleAvatar(
                backgroundColor: bone,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: primary,
                  ),
                ),
              ),
              title: Text(
                data.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                data.nis,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${data.kelas} ${data.jurusan}",
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    jk,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: value.isMultiple,
              child: Positioned(
                left: 40,
                bottom: 6,
                child: value.selectedPresents.contains(data)
                    ? const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: primary,
                          size: 20,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        );
      },
    );
  }
}
