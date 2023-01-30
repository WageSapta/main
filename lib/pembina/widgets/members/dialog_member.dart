import '../../globalwidget/global.dart';
import '../../models/peserta.dart';
import '../../provider/members_provider_class..dart';
import 'form_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../constant/color.dart';

class DialogMember extends StatefulWidget {
  final Peserta siswa;
  const DialogMember({
    Key? key,
    required this.siswa,
  }) : super(key: key);

  @override
  State<DialogMember> createState() => _DialogMemberState();
}

class _DialogMemberState extends State<DialogMember> {
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
    var siswa = widget.siswa;
    return Consumer<MembersProviderClass>(builder: (context, value, child) {
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
                indent: 20,
                endIndent: 20,
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${siswa.nama} (${siswa.jenisKelamin})",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          siswa.nis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Text(
                        "${siswa.kelas} ${siswa.jurusan}",
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
                  children: List.generate(
                    2,
                    (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primary,
                              fixedSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(["Delete", "Edit"][index]),
                            onPressed: () async {
                              if (index == 0) {
                                value.deleteMember(siswa.id).then((e) async {
                                  value.refreshData().then((value) {
                                    Navigator.of(context).pop();
                                    EasyLoading.showToast(e.toString(),
                                        toastPosition:
                                            EasyLoadingToastPosition.bottom);
                                  });
                                }).catchError((e) {
                                  EasyLoading.showToast(e.toString(),
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                });
                              } else {
                                Navigator.pop(context);
                                push(context,
                                    FormMembers(edit: true, siswa: siswa));
                              }
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
