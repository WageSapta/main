import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/history.dart';
import '../../provider/pembina_provider_class.dart';
import '../../provider/session.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final ff = FirebaseFirestore.instance;
  String idEkstra = "";
  List<HistoryPresent> data = [];
  Future<HistoryPresentsModel>? _history;
  DateTime selectedDate = DateTime.now();
  String? _dateTimeDay;
  String? _dateTimeClock;

  Timer? timer;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateTimeDay = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _getTime() {
    final String day = DateFormat('dd-MM-yyyy').format(selectedDate);
    final String clock = DateFormat('hh:mm:ss').format(selectedDate);
    setState(() {
      _dateTimeDay = day;
      _dateTimeClock = clock;
    });
  }

  Future<HistoryPresentsModel>? _getHistory() async {
    var user = Provider.of<UserProviderClass>(context).pembina;
    // var response = await CallApi()
    //     .getSpesificHistory("/get", {"id_ekstra": user!.idEkstra});
    // history = historyPresentsModelFromJson(response.body);
    return history!;
  }

  sort(date) {
    data = history!.data.where((element) => element.tanggal == date).toList();
  }

  @override
  void initState() {
    Shared.getIdEkstra().then((e) => setState(() => idEkstra = e));
    // _dateTimeDay = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // _dateTimeClock = DateFormat('hh:mm:ss').format(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    setState(() {
      _history = _getHistory();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("absents")
            .where('idEkstra', isEqualTo: idEkstra)
            // .where('tanggal',isEqualTo: tgl)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            EasyLoading.showToast(snapshot.error.toString());
          }
          if (snapshot.data!.docs.isEmpty) {
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
                    "Absents doesn't exist",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            );
          }
          List<Map<String, dynamic>> absents = [];
          // absents.clear();
          snapshot.data!.docs.map((e) async {
            var siswa = await ff
                .collection('siswas')
                .doc((e.data() as Map)['idSiswa'])
                .get();
            // var ekstra = await ff
            //     .collection('ekstrakurikulers')
            //     .doc((e.data() as Map)['idEkstra'])
            //     .get();
            print(siswa.data());
            // absents = siswa
            //     .data()!
            //     .entries
            //     .map((f) => {
            //           'id': e.reference.id,
            //           'nama': siswa.data()!['nama'],
            //           'ekstra': ekstra.data()!['nama'],
            //           'kelas': siswa.data()!['kelas'],
            //           'jurusan': siswa.data()!['jurusan'],
            //           'jenisKelamin': siswa.data()!['jenisKelamin'],
            //           'tanggal': (e.data() as Map)['tanggal']
            //         })
            //     .toList();

            // print(e.data());

            // (absents as Map)['id'] = e.reference.id;
            // (absents as Map)['nama'] = siswa.data()!['nama'];
            // (absents as Map)['ekstra'] = ekstra.data()!['nama'];
            // (absents as Map)['kelas'] = siswa.data()!['kelas'];
            // (absents as Map)['jurusan'] = siswa.data()!['jurusan'];
            // (absents as Map)['jenisKelamin'] = siswa.data()!['jenisKelamin'];
            // (absents as Map)['tanggal'] = (e.data() as Map)['tanggal'];
          }).toList();

          print(absents);

          return ListView.builder(
            itemCount: absents.length,
            itemBuilder: (context, index) {
              final data = absents[index];
              return ExpansionTile(
                  title: Text(
                    data['tanggal'],
                  ),
                  subtitle: Text(data['-']),
                  children: absents.map((e) {
                    return ListTile(
                      title: e['namaSiswa'],
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            e['kelas'] + " " + e['jurusan'],
                            style: const TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            e['jenisKelamin'],
                            style: const TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList());
            },
          );
        },
      ),
    );
  }
}
