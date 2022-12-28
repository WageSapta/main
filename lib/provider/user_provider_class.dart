import 'package:ekskul/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProviderClass extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  bool get loading => _loading;
  User? get user => _user;

  void setUser(User data) {
    _loading = true;
    notifyListeners();
    _user = data;
    _loading = false;
    notifyListeners();
  }
}
