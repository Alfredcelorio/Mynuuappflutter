import 'package:flutter/material.dart';
import 'package:project1/common/models/restaurant.dart';

class Providers extends ChangeNotifier {
  Restaurant r = Restaurant.empty();

  void changeR(Restaurant value) {
    r = value;
    notifyListeners();
  }
}
