import 'dart:math' as math;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ekskul/constant/color.dart';
import 'pembina/firebasemethod/pembina.dart';
import 'pembina/pages/navbar.dart';
import 'pembina/globalwidget/global.dart';
import 'pembina/models/user.dart';
import 'pembina/provider/auth_provider_class.dart';
import 'pembina/provider/ekstra_provider_class.dart';
import 'pembina/provider/pembina_provider_class.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => SignPageState();
}

class SignPageState extends State<SignPage> {
  final _keyform1 = GlobalKey<FormState>();
  final _keyform2 = GlobalKey<FormState>();
  final idEkstra = TextEditingController();
  final nama = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmed = TextEditingController();
  bool _hide = true;
  bool _hideReg = true;
  bool? _changePage;

  validation(bool change, BuildContext context, AuthProviderClass auth) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    if (change == true) {
      final form1 = _keyform1.currentState!;
      if (form1.validate()) {
        form1.save();
        auth
            .signIn(email: email.text.trim(), password: password.text.trim())
            .then((value) {
          Provider.of<EkstraProviderClass>(context, listen: false)
              .getEkstrakurikulers();
          Provider.of<UserProviderClass>(context, listen: false).ekstra =
              value[0];
          Provider.of<UserProviderClass>(context, listen: false).peserta =
              value[1];
          Provider.of<UserProviderClass>(context, listen: false).pembina =
              value[2];
          EasyLoading.showToast("Selamat datang ${(value[2] as Pembina).nama}",
              toastPosition: EasyLoadingToastPosition.top,
              duration: const Duration(seconds: 1));
          pushreplacement(context, const Navbar());
        }).catchError((e) {
          EasyLoading.showToast(
            auth.determineError(e),
            toastPosition: EasyLoadingToastPosition.bottom,
          );
        }).asStream();
      }
    }

    if (change == false) {
      final form2 = _keyform2.currentState;
      if (form2!.validate()) {
        form2.save();
        auth
            .signUp(
          idEkstra: idEkstra.text.trim(),
          email: email.text.trim(),
          password: password.text.trim(),
          nama: nama.text.trim(),
        )
            .then((value) {
          auth.loading = false;
          Provider.of<UserProviderClass>(context, listen: false).pembina =
              value;
          EasyLoading.showToast('SignUp Success',
              toastPosition: EasyLoadingToastPosition.bottom,
              duration: const Duration(seconds: 1));
          pushreplacement(context, const Navbar());
        }).catchError((e) {
          EasyLoading.showToast(
            auth.determineError(e),
            toastPosition: EasyLoadingToastPosition.bottom,
          );
        });
      }
    }
  }

  dropDownButton(List<QueryDocumentSnapshot> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        isExpanded: false,
        hint: const Text(
          'Select Extracurricular',
          style: TextStyle(),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 60,
        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: data
            .map((item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(
                    item.get('nama'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Select Extracurricular';
          }
          return null;
        },
        onChanged: (value) {
          idEkstra.text = value.toString();
        },
        onSaved: (value) {
          idEkstra.text = value.toString();
        },
        // onSaved: (value) {},
      ),
    );
  }

  fieldNama() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: TextFormField(
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "name",
          label: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text('Full Name'),
                )
              ],
            ),
          ),
          fillColor: Colors.white,
          // errorStyle: TextStyle(fontWeight: FontWeight.bold),
          filled: true,
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10),
              child: Icon(Icons.person_rounded, color: primary)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        cursorColor: primary,
        onSaved: (value) {
          nama.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Fill nama';
          }
          return null;
        },
      ),
    );
  }

  fieldEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "email",
          label: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text('Email'),
                )
              ],
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10),
              child: Icon(Icons.email_rounded, color: primary)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        cursorColor: primary,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          email.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Fill email';
          }
          if (!EmailValidator.validate(value)) {
            return 'Masukkan email yang valid';
          }
          return null;
        },
      ),
    );
  }

  fieldPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
      child: TextFormField(
        autofocus: false,
        textInputAction:
            _changePage == true ? TextInputAction.done : TextInputAction.next,
        obscureText: _changePage == true ? _hide : _hideReg,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _changePage! == true ? _hide = !_hide : _hideReg = !_hideReg;
                });
              },
              child: Icon(
                  _changePage == true
                      ? _hide
                          ? Icons.visibility_off
                          : Icons.visibility
                      : _hideReg
                          ? Icons.visibility_off
                          : Icons.visibility,
                  color: _changePage == true ? primary : primary),
            ),
          ),
          hintText: "Password",
          label: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text('Password'),
                )
              ],
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10),
              child: Icon(Icons.lock_rounded, color: primary)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        cursorColor: primary,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          password.text = value;
        },
        onSaved: (value) {
          password.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Fill password';
          }
          if (value.length < 6) {
            return 'Fill password minimal 6';
          }
          return null;
        },
      ),
    );
  }

  fieldPasswordConfirmation() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
      child: TextFormField(
        autofocus: false,
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          label: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text('Confirm Password'),
                )
              ],
            ),
          ),
          hintText: "confirm password",
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 10),
              child: Icon(Icons.lock_rounded, color: primary)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        cursorColor: primary,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          passwordConfirmed.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Fill password';
          }
          if (value.length < 6) {
            return 'Fill password minimal 6';
          }
          if (!(password.text == value)) {
            return 'Password confirmed does not match';
          }
          return null;
        },
      ),
    );
  }

  Widget rightWidget(context) {
    return Transform.rotate(
      angle: 30 * math.pi / 180,
      child: Container(
        width: 1.2 * MediaQuery.of(context).size.width,
        height: 1.2 * MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
            color: Colors.blue
            // gradient: LinearGradient(
            //   begin: Alignment(-0.2, -0.8),
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0x007CBFCF),
            //     // Color(0xB316BFC4),
            //     Colors.blue
            //   ],
            // ),
            ),
      ),
    );
  }

  Widget leftWidget(context) {
    return Transform.rotate(
      angle: 30 * math.pi / 180,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 1.2 * MediaQuery.of(context).size.width,
          height: 1.2 * MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(150)),
              color: primary),
        ),
      ),
    );
  }

  Widget centerWidget(context) {
    return Transform.rotate(
        angle: 30 * math.pi / 180,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 7,
            sigmaY: 7,
          ),
          child: Container(
            width: 1.2 * MediaQuery.of(context).size.width,
            height: 1.2 * MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(.3)),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(100)),
              color: const Color(0xB316BFC4).withOpacity(.2),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _changePage = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nama.dispose();
    email.dispose();
    password.dispose();
    passwordConfirmed.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderClass>(
      builder: (context, auth, child) {
        print(auth.loading);
        if (auth.loading) {
          EasyLoading.show(
            dismissOnTap: true,
            status: 'Loading...',
            maskType: EasyLoadingMaskType.black,
            indicator: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned(
                    top: -180,
                    right: -351,
                    child: centerWidget(context),
                  ),
                  Positioned(
                    top: -120,
                    right: -370,
                    child: rightWidget(context),
                  ),
                  Positioned(
                    top: -220,
                    left: -260,
                    child: leftWidget(context),
                  ),
                  Positioned(
                    top: 50,
                    left: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _changePage! == true ? 'Login' : 'Register',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _changePage! == true
                                  ? 'Login to continue'
                                  : 'Register to continue',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 21,
                    right: 5,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          PembinaFirebase().getEkstra(auth.userCredential);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Image.asset(
                        'assets/images/logo2.png',
                        color: Colors.white,
                        scale: 9,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: auth.ff
                        .collection('ekstrakurikulers')
                        .orderBy('nama')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        EasyLoading.showToast('Something is wrong',
                            toastPosition: EasyLoadingToastPosition.bottom);
                      }
                      return Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.08,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(25),
                                  bottom: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: _changePage! == true
                                        ? _keyform1
                                        : _keyform2,
                                    child: Column(
                                      children: [
                                        _changePage! == true
                                            ? Container()
                                            : const SizedBox(height: 15),
                                        _changePage! == true
                                            ? Container()
                                            : dropDownButton(
                                                snapshot.data!.docs),
                                        _changePage! == true
                                            ? Container()
                                            : fieldNama(),
                                        _changePage! == true
                                            ? const SizedBox(height: 15)
                                            : Container(),
                                        fieldEmail(),
                                        fieldPassword(),
                                        _changePage! == true
                                            ? Container()
                                            : fieldPasswordConfirmation(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Button Login
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                maximumSize: const Size(
                                                    double.infinity,
                                                    double.infinity),
                                              ),
                                              onPressed: () {
                                                validation(_changePage!,
                                                    context, auth);
                                              },
                                              child: Text(
                                                _changePage! == true
                                                    ? "Login"
                                                    : "Register",
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _changePage! == false
                                                      ? 'Already have an account? '
                                                      : 'Don\'t have an account? ',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _changePage =
                                                          !_changePage!;
                                                    });
                                                  },
                                                  child: Text(
                                                    _changePage! == false
                                                        ? 'Log In'
                                                        : 'Sign Up',
                                                    style: const TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
