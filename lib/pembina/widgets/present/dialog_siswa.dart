import '../../models/peserta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '/constant/color.dart';
import '../../provider/presenst_provider_class.dart';

class DialogSiswa extends StatefulWidget {
  final Peserta siswa;
  const DialogSiswa({
    Key? key,
    required this.siswa,
  }) : super(key: key);

  @override
  State<DialogSiswa> createState() => _DialogSiswaState();
}

class _DialogSiswaState extends State<DialogSiswa> {
  @override
  Widget build(BuildContext context) {
    var siswa = widget.siswa;
    return Consumer<PresentsProviderClass>(builder: (context, value, child) {
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
                    const Text(
                      'Detail Student',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      splashRadius: 25,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  children: List.generate(
                    ["Alpha", "Izin", "Hadir"].length,
                    (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primary,
                              fixedSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(["Alpha", "Izin", "Hadir"][index]),
                            onPressed: () async {
                              Navigator.pop(context);
                              value
                                  .doAbsensi(
                                idSiswa: siswa.id!,
                                absensi: ["Alpha", "Izin", "Hadir"][index],
                              )
                                  .then((_) {
                                value.getData;
                                EasyLoading.showToast('Absent success',
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                              }).catchError((e) {
                                EasyLoading.showToast('Absent failed',
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                              });
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
    });
  }
}
