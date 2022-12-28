import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/services.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/color.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<FormState>();
  String namaLocal = "";
  Map data = {
    "labels": <String>["Name", "Name Extracurricular"],
    "bl": <bool>[],
    "controllers": <TextEditingController>[],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController textEditingController in data['controllers']) {
      textEditingController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProviderClass>(context).user;
    namaLocal = user!.nama;
    data['bl'] = [true, true];
    List prof = [
      user.nama,
      user.ekstra.namaEkstra,
    ];
    for (var str in prof) {
      var textEditingController = TextEditingController(text: str);
      (data['controllers'] as List).add(textEditingController);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done_rounded,
            ),
          )
        ],
        title: const Text(
          "Edit profile",
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.image.isEmpty
                            ? null
                            : NetworkImage(Api.urlImage + user.image),
                        backgroundColor: bone,
                        child: user.image.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: primary,
                                ),
                              )
                            : const SizedBox(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 25, 134, 224),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _key,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data['labels'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            cursorColor: primary,
                            onChanged: (value) {
                              _key.currentState!.validate();
                              if (data['labels'][index] ==
                                  data["labels"][index]) {
                                if (data['labels'][index] == "Name") {
                                  setState(() {
                                    namaLocal = value;
                                  });
                                }
                                if (value.isEmpty) {
                                  setState(() {
                                    data['bl'][index] = false;
                                  });
                                }
                                if (value.isNotEmpty) {
                                  setState(() {
                                    data['bl'][index] = true;
                                  });
                                }
                              }
                            },
                            enabled: true,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            controller: data['controllers'][index],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill ${data['labels'][index]}"
                                    .toLowerCase();
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              enabled: true,
                              suffixIconColor: data['bl'][index] == true
                                  ? Colors.green
                                  : Colors.red,
                              suffixIcon: Icon(
                                data['bl'][index] == true
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.cancel_outlined,
                                color: data['bl'][index] == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: data['bl'][index] == true
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: data['bl'][index] == true
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              label: Text(
                                data['labels'][index],
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
