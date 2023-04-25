import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/restaurant.dart';

import 'landing_service.dart';

enum StatusLoad { load, error, empty }

class LikesProvider extends ChangeNotifier {
  final CloudFirestoreService _dbService = CloudFirestoreService();
  Product? product;
  List<Product> prods = [];
  String nameCategory = '';
  StatusLoad statusLoad = StatusLoad.empty;

  Future<void> loadLikesProducts(String rId, List<String> idsProd) async {
    prods.clear();
    try {
      final result = await _dbService.getProductsByRestaurant(rId);
      if (result.isNotEmpty) {
        for (var i = 0; i < idsProd.length; i++) {
          for (var j = 0; j < result.length; j++) {
            if (idsProd[i] == result[j].id) {
              prods.add(result[j]);
            }
          }
        }
        statusLoad = StatusLoad.load;
      }
    } catch (error) {
      statusLoad = StatusLoad.error;
      print(error.toString());
    }
    notifyListeners();
  }

  Future<void> getNameCategory(String rId) async {
    try {
      final c = await _dbService.getCategoryById(rId);
      nameCategory = c.name;
    } catch (error) {
      print(error.toString());
    }
    notifyListeners();
  }

  void changeProduct(Product p) {
    product = p;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
