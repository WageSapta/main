import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../models/peserta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../../constant/color.dart';
import '../../provider/members_provider_class..dart';

class FormMembers extends StatefulWidget {
  final bool edit;
  final Peserta? siswa;
  const FormMembers({Key? key, this.edit = false, this.siswa})
      : super(key: key);

  @override
  State<FormMembers> createState() => _FormMembersState();
}

class _FormMembersState extends State<FormMembers> {
  final _key = GlobalKey<FormState>();
  final nisController = TextEditingController();
  final nameController = TextEditingController();
  final classController = TextEditingController();
  final majorController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  List<String> majors = [];
  String? _selectedClass;
  String? get selectedClass => _selectedClass;
  set selectedClass(String? val) => setState(() => _selectedClass = val);
  String? _selectedMajor;
  String? get selectedMajor => _selectedMajor;
  set selectedMajor(String? val) => setState(() => _selectedMajor = val);

  Map data = {
    'titles': ['Nis', 'Name', 'Class', 'Major', 'Age', "Gender"],
    'controllers': <TextEditingController>[],
    'textinputypes': [
      TextInputType.number,
      TextInputType.name,
      TextInputType.text,
      TextInputType.text,
      TextInputType.number,
      TextInputType.text
    ]
  };

  getMajors() async {
    var data =
        await FirebaseFirestore.instance.collection('admin').doc('class').get();
    for (var t in ['10', '11', '12']) {
      for (String e in data.get(t)) {
        if (majors
            .where((element) => element == e.substring(2).trimLeft())
            .isEmpty) {
          majors.add(e.substring(2).trimLeft());
        }
      }
    }
    majors.sort((a, b) => a.compareTo(b));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMajors();
    (data['controllers'] as List<TextEditingController>).addAll([
      nisController,
      nameController,
      classController,
      majorController,
      ageController,
      genderController
    ]);
  }

  String? nama;

  @override
  void dispose() {
    super.dispose();
    nisController.dispose();
    nameController.dispose();
    classController.dispose();
    majorController.dispose();
    ageController.dispose();
    genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.edit) {
      nisController.text = widget.siswa!.nis;
      nameController.text = widget.siswa!.nama;
      classController.text = widget.siswa!.kelas;
      majorController.text = widget.siswa!.jurusan;
      ageController.text = widget.siswa!.umur;
      genderController.text = widget.siswa!.jenisKelamin;
    }
    return Consumer<MembersProviderClass>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text("${widget.edit ? "Edit" : "Add"} Member")),
          body: Consumer<MembersProviderClass>(
            builder: (context, value, child) {
              if (value.loading) {
                EasyLoading.show(
                        indicator: const CircularProgressIndicator(
                            color: Colors.white),
                        status: 'Loading...')
                    .then((e) {
                  EasyLoading.dismiss();
                  // if (!value.loading) EasyLoading.dismiss();
                });
              }
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data['titles'].length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (data['titles'][index] == "Class" ||
                                  data['titles'][index] == "Major")
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      labelText: data['titles'][index],
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.only(left: 11),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (e) {
                                      if (e == null) {
                                        return "Select ${data['titles'][index] == 'Class' ? 'Class' : 'Major'}";
                                      }
                                      return null;
                                    },
                                    value: widget.edit
                                        ? data['titles'][index] == 'Class'
                                            ? classController.text
                                            : majorController.text
                                        : null,
                                    selectedItemHighlightColor:
                                        Colors.grey[200],
                                    buttonHeight: 55,
                                    dropdownMaxHeight: 200,
                                    dropdownWidth: 330,
                                    scrollbarAlwaysShow: true,
                                    buttonPadding:
                                        const EdgeInsets.only(right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onChanged: (String? value) {
                                      if (data['titles'][index] == "Class") {
                                        classController.text = value!;
                                      } else {
                                        majorController.text = value!;
                                      }
                                    },
                                    items: (data['titles'][index] == "Class"
                                            ? ['10', '11', '12']
                                            : majors)
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              else if (data['titles'][index] == "Gender")
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      labelText: data['titles'][index],
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.only(left: 11),
                                      // isCollapsed: true,
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (e) {
                                      if (e == null) {
                                        return "Select ${data['titles'][index]}";
                                      }
                                      return null;
                                    },
                                    value: widget.edit
                                        ? genderController.text
                                        : null,
                                    selectedItemHighlightColor:
                                        Colors.grey[200],
                                    buttonHeight: 55,
                                    dropdownMaxHeight: 200,
                                    dropdownWidth: 330,
                                    buttonPadding:
                                        const EdgeInsets.only(right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onChanged: (value) {
                                      genderController.text = value as String;
                                    },
                                    items: ["Laki Laki", "Perempuan"]
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e == "Perempuan" ? "P" : "L",
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextFormField(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    maxLength: 50,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.go,
                                    // initialValue:
                                    //     widget.edit ? selectedSiswa[index] : null,
                                    inputFormatters: [
                                      if (data['titles'][index] != "Name")
                                        FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: data['textinputypes'][index],
                                    controller: data['controllers'][index],
                                    decoration: InputDecoration(
                                      labelStyle: const TextStyle(
                                          fontWeight: FontWeight.w100),
                                      counterText: "",
                                      labelText: data['titles'][index],
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black54),
                                      ),
                                    ),
                                    cursorColor: primary,
                                    validator: (e) {
                                      if (e!.isEmpty) {
                                        return 'Fill ${data['titles'][index]}';
                                      }
                                      return null;
                                      // return null;
                                    },
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          primary: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                        ),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            FocusManager.instance.primaryFocus!.unfocus();
                            if (widget.edit) {
                              value
                                  .updateMember(
                                nisCek: widget.siswa!.nis,
                                id: widget.siswa!.id!,
                                nis: nisController.text.trim(),
                                name: nameController.text.trim(),
                                classs: classController.text.trim(),
                                major: majorController.text.trim(),
                                age: ageController.text.trim(),
                                gender: genderController.text.trim(),
                              )
                                  .then((e) {
                                value.loading = false;
                                value.refreshData().whenComplete(() {
                                  EasyLoading.showToast(e.toString(),
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                  Navigator.pop(context);
                                });
                              }).catchError(
                                (e) {
                                  EasyLoading.showToast(e,
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                },
                              );
                            } else {
                              value
                                  .postMember(
                                nis: nisController.text.trim(),
                                name: nameController.text.trim(),
                                classs: classController.text.trim(),
                                major: majorController.text.trim(),
                                age: ageController.text.trim(),
                                gender: genderController.text.trim(),
                              )
                                  .then((e) {
                                value.loading = false;
                                value.refreshData().whenComplete(() {
                                  EasyLoading.showToast(e.toString(),
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                  Navigator.pop(context);
                                });
                              }).catchError(
                                (e) {
                                  EasyLoading.showToast(e.toString(),
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom);
                                },
                              );
                            }
                          }
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
