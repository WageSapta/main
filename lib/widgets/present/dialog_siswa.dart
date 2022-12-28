import 'package:ekskul/constant/color.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../provider/presenst_provider_class.dart';

class DialogSiswa extends StatefulWidget {
  final Peserta siswa;
  const DialogSiswa({Key? key, required this.siswa}) : super(key: key);

  @override
  State<DialogSiswa> createState() => _DialogSiswaState();
}

class _DialogSiswaState extends State<DialogSiswa> {
  Map<String, List> data = {
    "titles": ["Alpha", "Izin", "Hadir"],
    "colors": [Colors.red, Colors.yellow[600], Colors.green],
  };

  @override
  void initState() {
    super.initState();
    FToast().init(context);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProviderClass>(context);
    var present = Provider.of<PresentsProviderClass>(context);
    var siswa = widget.siswa;
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
              padding:
                  const EdgeInsets.only(left: 18, top: 5, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Siswa',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
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
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      siswa.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      siswa.kelas,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "${siswa.kelas} ${siswa.jurusan}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      siswa.jenisKelamin,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            present.postPresents(
                              idEkstra: user.user!.idEkstra.toString(),
                              idSiswa: siswa.id.toString(),
                              jenisAbsen: data['titles']![index]
                                  .toString()
                                  .toLowerCase(),
                              tanggal: DateFormat('y-M-d')
                                  .format(DateTime.now().toLocal()),
                            );
                            Navigator.pop(context);
                            present.getPresents();
                            FToast().showToast(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Absen Success',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: const Duration(seconds: 2),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: data['colors']![index] as Color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Text(data['titles']![index]),
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
  }
}
