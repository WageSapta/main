import 'dart:async';
import 'package:ekskul/constant/color.dart';
import 'package:ekskul/models/history.dart';
import 'package:ekskul/provider/auth_provider_class.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
    var user = Provider.of<UserProviderClass>(context).user;
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
    // _dateTimeDay = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _dateTimeClock = DateFormat('hh:mm:ss').format(DateTime.now());
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
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text('History', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 120,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      offset: const Offset(3, 5),
                      spreadRadius: 3,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat("EEEE").format(selectedDate.toLocal()),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat("dd-MM-yyyy")
                                .format(selectedDate.toLocal()),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              primary: primary,
                            ),
                            onPressed: () => {
                              _selectDate(context),
                            },
                            child: const Text('Pilih Tanggal'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<HistoryPresentsModel>(
              future: _history,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var data = history!.data;
                    return history!.total == 0
                        ? const Center(
                            child: Text(
                              'History not found',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index].nama,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "${data[index].kelas} ${data[index].jurusan}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index].jenisAbsen,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            data[index].tanggal,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
