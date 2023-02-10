import 'dart:convert';

import 'package:project1/common/models/mynuu_model.dart';

class ProductCategory implements MynuuModel {
  final String id;
  final String name;
  final bool status;
  final String menuId;
  final String restaurantId;
  int position;

  ProductCategory({
    required this.id,
    required this.name,
    required this.status,
    required this.menuId,
    required this.restaurantId,
    required this.position,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'restaurantId': restaurantId,
      'menuId': menuId,
      'position': position,
    };
  }

  factory ProductCategory.fromMap(String id, Map<String, dynamic> map) {
    return ProductCategory(
      id: id,
      name: map['name'] ?? '',
      status: map['status'] ?? false,
      restaurantId: map['restaurantId'] ?? '',
      menuId: map['menuId'] ?? '',
      position: map['position'] ?? 1000,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromJson(String id, String source) =>
      ProductCategory.fromMap(
        id,
        json.decode(
          source,
        ),
      );
}
