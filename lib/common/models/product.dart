import 'dart:convert';

import 'package:project1/common/models/mynuu_model.dart';

class Product implements MynuuModel {
  final String id;
  final String name;
  String image;
  final String description;
  final String categoryId;
  bool enabled;
  final String? price;
  final int views;
  bool deleted;
  final String restaurantId;
  final String? keyword;
  int positionInCategory;
  String? menuId;
  String? countryState;
  String? body;
  String? abv;
  String? brand;
  String? region;
  String? sku;
  String? type;
  String? varietal;
  String? taste;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.categoryId,
    required this.enabled,
    required this.price,
    required this.deleted,
    this.abv,
    this.body,
    this.brand,
    this.countryState,
    this.region,
    this.varietal,
    this.sku,
    this.taste,
    this.type,
    this.views = 0,
    required this.restaurantId,
    required this.positionInCategory,
    this.keyword,
    this.menuId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'categoryId': categoryId,
      'enabled': enabled,
      'price': price,
      'views': views,
      'deleted': deleted,
      'restaurantId': restaurantId,
      'keyword': _getKeyword(),
      'positionInCategory': positionInCategory,
      'menuId': menuId,
      'abv': abv,
      'body': body,
      'brand': brand,
      'countryState': countryState,
      'region': region,
      'varietal': varietal,
      'sku': sku,
      'taste': taste,
      'type': type
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    map['price'] = map['price'] != null
        ? map['price'] is int
            ? map['price']
            : map['price']
        : '';
    if (map['price'].toString().contains('.0')) {
      map['price'] = map['price'].toString().replaceAll('.0', '');
    }
    return Product(
        id: id,
        name: map['name'] ?? '',
        image: map['image'] ?? '',
        description: map['description'] ?? '',
        categoryId: map['categoryId'] ?? '',
        enabled: map['enabled'] ?? false,
        price: map['price'].toString(),
        views: map['views'] ?? 0,
        deleted: map['deleted'] ?? false,
        restaurantId: map['restaurantId'] ?? '',
        keyword: map['keyword'],
        positionInCategory: map['positionInCategory'] ?? 0,
        menuId: map['menuId'],
        abv: map['abv'] ?? '',
        body: map['body'] ?? '',
        brand: map['brand'] ?? '',
        countryState: map['countryState'] ?? '',
        region: map['region'] ?? '',
        sku: map['sku'] ?? '',
        taste: map['taste'] ?? '',
        type: map['type'] ?? '',
        varietal: map['varietal'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String id, String source) => Product.fromMap(
        id,
        json.decode(source),
      );

  String _getKeyword() {
    return name.toLowerCase();
  }
}
