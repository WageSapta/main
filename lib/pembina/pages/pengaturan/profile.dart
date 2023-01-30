import '../../provider/pembina_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '/constant/color.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String namaLocal = "";
  Map data = {
    "titles": <String>["Name", "Email"],
    "controllers": <TextEditingController>[],
  };

  @override
  void initState() {
    super.initState();
    (data['controllers'] as List<TextEditingController>)
        .addAll([nameController, emailController]);
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController e in data['controllers']) {
      e.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProviderClass>(
      builder: (context, value, child) {
        nameController.text = value.pembina.nama;
        emailController.text = value.pembina.email;
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () => value
                      .updateUser(value.pembina.id, nameController.text)
                      .then((value) {
                    EasyLoading.showToast(value,
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }).catchError((e) {
                    EasyLoading.showToast(e,
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }),
                  splashRadius: 25,
                  icon: const Icon(
                    Icons.done_rounded,
                  ),
                ),
              )
            ],
            title: const Text(
              "Edit profile",
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: value.pembina.image.isEmpty
                                ? null
                                : NetworkImage(value.pembina.image),
                            backgroundColor: bone,
                            child: value.pembina.image.isEmpty
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _key,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data['titles'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextFormField(
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLength: 50,
                          maxLines: 1,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          readOnly:
                              data['controllers'][index] == emailController
                                  ? true
                                  : false,
                          controller: data['controllers'][index],
                          decoration: InputDecoration(
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w100),
                            counterText: "",
                            labelText: data['titles'][index],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
