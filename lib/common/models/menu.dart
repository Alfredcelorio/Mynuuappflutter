import 'dart:convert';

import 'package:project1/common/models/mynuu_model.dart';

class Menu implements MynuuModel {
  final String id;
  final String name;
  final String restaurantId;
  final int position;
  final bool status;

  Menu(
      {required this.id,
      required this.name,
      required this.restaurantId,
      this.position = 0,
      this.status = true});

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'restaurantId': restaurantId,
      'position': position,
      'status': status
    };
  }

  factory Menu.fromMap(String id, Map<String, dynamic> map) {
    return Menu(
      id: id,
      name: map['name'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      position: map['position'] ?? 0,
      status: map['status'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String id, String source) => Menu.fromMap(
        id,
        json.decode(source),
      );
}
