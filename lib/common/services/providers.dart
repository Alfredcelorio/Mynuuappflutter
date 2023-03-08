import 'package:flutter/material.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/models/restaurant.dart';

import 'landing_service.dart';

class Providers extends ChangeNotifier {
  Restaurant r = Restaurant.empty();
  int valuePage = 0;
  final CloudFirestoreService _dbService = CloudFirestoreService();
  List<Guest> guest = [];
  void changeR(Restaurant value) {
    r = value;
    notifyListeners();
  }

  void changeValuePage(int value) {
    valuePage = value;
    notifyListeners();
  }

  Future<List<Guest>> getGuest() async {
    guest = [];
    final result = await _dbService.getGuests(r.id);
    guest = result;
    notifyListeners();
    return result;
  }
}

List<Guest> filterDate(List<Guest> guests, DateTime valueFilter) {
  List<Guest> dataReturn = [];
  for (var i = 0; i < guests.length; i++) {
    final valueGuest = guests[i].lastVisit != null
        ? guests[i].lastVisit!.toDate()
        : DateTime.now();
    if (valueGuest.year == valueFilter.year &&
        valueGuest.month == valueFilter.month &&
        valueGuest.day == valueGuest.day) {
      dataReturn.add(guests[i]);
    }
  }

  return dataReturn;
}
