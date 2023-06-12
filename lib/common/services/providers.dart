import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<Guest>> getGuest(String token) async {
    guest = [];
    if (token.isNotEmpty) {
      guest = await _dbService.getGuestsStaff(r.id, token);
    } else {
      guest = await _dbService.getGuests(r.id);
    }

    notifyListeners();
    return guest;
  }
}

List<Guest> filterDate(List<Guest> guests, DateTime valueFilter) {
  List<Guest> dataReturn = [];

  if (guests.isEmpty) return dataReturn;

  for (var i = 0; i < guests.length; i++) {
    final valueGuest = guests[i].lastVisit != null
        ? guests[i].lastVisit!.toDate()
        : DateTime.now();

    guests[i].lastVisit =
        guests[i].lastVisit == null ? Timestamp.now() : guests[i].lastVisit!;

    if (valueGuest.year == valueFilter.year &&
        valueGuest.month == valueFilter.month &&
        valueGuest.day == valueFilter.day) {
      dataReturn.add(guests[i]);
    }
  }

  dataReturn
      .sort((a, b) => a.lastVisit!.toDate().compareTo(b.lastVisit!.toDate()));
  return dataReturn.reversed.toList();
}
