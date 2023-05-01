import 'package:flutter/material.dart';

class NfcPlugin extends ChangeNotifier {
  String msg = '';

  void changeMsg(String msg) {
    this.msg = msg;
    notifyListeners();
  }
}
