import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/models/menu.dart';
import 'package:project1/common/models/mynuu_model.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/restaurant.dart';

class CloudFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductCategory>> streamCategories(
    String restaurantId, {
    int? limit,
  }) {
    var ref = _db
        .collection('categories')
        .where(
          'restaurantId',
          isEqualTo: restaurantId,
        )
        .orderBy('position', descending: false);
    if (limit != null) {
      ref = ref.limit(limit);
    }
    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => ProductCategory.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Menu>> getMenus(String restaurantId) async {
    var ref = _db.collection('menus').where(
          'restaurantId',
          isEqualTo: restaurantId,
        );

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Menu.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<Map<String, dynamic>> getIdMenu(String emailUser) async {
    var ref = await _db
        .collection('guestPostbyAdmin')
        .where('email', isEqualTo: emailUser)
        .limit(1)
        .get()
        .then(
          (snap) => snap.docs
              .map(
                (restaurant) => restaurant.data(),
              )
              .toList(),
        );
    return ref.isEmpty ? {} : ref.first;
  }

  Future<List<Map<String, dynamic>>> getInvited() {
    //add two values userID and string global
    var ref = _db.collection('guestPostbyAdmin');

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }

  Future<List<Restaurant>> getRestaurants() {
    //add two values userID and string global
    var ref = _db.collection('restaurants');

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Restaurant.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<ProductCategory>> getCategories(String restaurantId) async {
    var ref = _db.collection('categories').where(
          'restaurantId',
          isEqualTo: restaurantId,
        );

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => ProductCategory.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Product>> getProductsByCategory(String categoryId) {
    //add two values userID and string global
    var ref = _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('deleted', isEqualTo: false);

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Guest>> getGuests(String restaurantId) {
    //add two values userID and string global
    var ref = _db.collection('guests').where(
          'restaurantId',
          isEqualTo: restaurantId,
        );

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Guest.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Guest>> getGuestsStaff(String restaurantId, String token) {
    //add two values userID and string global
    var ref = _db
        .collection('guests')
        .where(
          'restaurantId',
          isEqualTo: restaurantId,
        )
        .where('token', isEqualTo: token);

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Guest.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Product>> streamProductByCategory(String categoryId) {
    //add two values userID and string global
    var ref = _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('deleted', isEqualTo: false);

    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Product>> streamEnabledProductByCategory(String categoryId) {
    //add two values userID and string global
    var ref = _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('enabled', isEqualTo: true)
        .where('deleted', isEqualTo: false);

    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Product>> streamEnabledFalseProductByCategory(String categoryId) {
    //add two values userID and string global
    var ref = _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('enabled', isEqualTo: false)
        .where('deleted', isEqualTo: false);

    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Product>> streamDeletedProducts(String restaurantId) {
    //add two values userID and string global
    var ref = _db
        .collection('products')
        .where(
          'deleted',
          isEqualTo: true,
        )
        .where(
          'restaurantId',
          isEqualTo: restaurantId,
        );

    return ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Stream<List<Guest>> streamGuests(String restaurantId) {
    print("rest: $restaurantId");
    //add two values userID and string global
    var ref = _db.collection('guests').where(
          'restaurantId',
          isEqualTo: restaurantId,
        );
    final result = ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Guest.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
    return result;
  }

  Stream<List<Guest>> streamGuestsStaff(String restaurantId, String token) {
    print("rest: $restaurantId");
    //add two values userID and string global
    var ref = _db
        .collection('guests')
        .where(
          'restaurantId',
          isEqualTo: restaurantId,
        )
        .where('token', isEqualTo: token);
    final result = ref.snapshots().map(
          (list) => list.docs
              .map(
                (doc) => Guest.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
    return result;
  }

  Future<List<Product>> searchProducts(
    String restaurantId,
    String searchText, {
    bool isPanelAdmin = false,
  }) async {
    searchText = searchText.toLowerCase();
    final strFrontCode = searchText.substring(0, searchText.length - 1);
    final strEndCode = searchText.characters.last;
    final limit =
        strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);

    var ref = _db
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('restaurantId', isEqualTo: restaurantId);

    if (!isPanelAdmin) {
      ref = ref.where('enabled', isEqualTo: true);
    }

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .where(
                  (element) => element.name.toLowerCase().contains(searchText))
              .toList(),
        );
  }

  Future<List<Product>> searchProductsEnableFalse(
    String restaurantId,
    String searchText, {
    bool isPanelAdmin = false,
  }) async {
    searchText = searchText.toLowerCase();
    final strFrontCode = searchText.substring(0, searchText.length - 1);
    final strEndCode = searchText.characters.last;
    final limit =
        strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);

    var ref = _db
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('enable', isEqualTo: false)
        .where('restaurantId', isEqualTo: restaurantId);

    // if (!isPanelAdmin) {
    //   ref = ref.where('enabled', isEqualTo: true);
    // }

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .where(
                  (element) => element.name.toLowerCase().contains(searchText))
              .toList(),
        );
  }

  Future<List<Product>> searchProductsByMenuId(
    String restaurantId,
    String menuId, {
    bool isPanelAdmin = false,
  }) async {
    var ref = _db
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('restaurantId', isEqualTo: restaurantId)
        .where("menuId", isEqualTo: menuId);

    if (!isPanelAdmin) {
      ref = ref.where('enabled', isEqualTo: true);
    }

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Product>> searchProductsByMenuIdEnableFalse(
    String restaurantId,
    String menuId, {
    bool isPanelAdmin = false,
  }) async {
    var ref = _db
        .collection('products')
        .where('deleted', isEqualTo: false)
        .where('enable', isEqualTo: false)
        .where('restaurantId', isEqualTo: restaurantId)
        .where("menuId", isEqualTo: menuId);

    // if (!isPanelAdmin) {
    //   ref = ref.where('enabled', isEqualTo: true);
    // }

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Product>> getProductsByCategoryId(
    String restaurantId,
    String categoryId,
  ) async {
    var ref = _db
        .collection('products')
        .where('restaurantId', isEqualTo: restaurantId)
        .where("categoryId", isEqualTo: categoryId);

    return ref.get().then(
          (value) => value.docs
              .map(
                (doc) => Product.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<Product> getProductById(String id) async {
    return _db.collection('products').doc(id).get().then(
          (snap) => Product.fromMap(
            snap.id,
            snap.data() ?? {},
          ),
        );
  }

  Future<List<Map<String, String>>> getGuestByAdmin(String id) async {
    List<Map<String, String>> idsR = [];
    final arrayMap = await _db.collection('guestPostbyAdmin').get().then(
          (snap) => snap.docs
              .map(
                (map) => map.data(),
              )
              .toList(),
        );
    for (var i = 0; i < arrayMap.length; i++) {
      final rests = arrayMap[i]['listRestaurants'] as List<dynamic>;
      for (var j = 0; j < rests.length; j++) {
        final res = rests[j] as Map<dynamic, dynamic>;
        if (res['email'] == id) {
          idsR.add({
            'idR': arrayMap[i]['owner'],
            'nameR': res['restaurantName'],
            'rol': res['rol'],
            'token': res.containsKey('token') ? res['token'] : ''
          });
        }
      }
    }

    return idsR;
  }

  Future<Restaurant> getRestaurantByShortUrl(String shortUrl) async {
    final restaurants = await _db
        .collection('restaurants')
        .where('shortUrl', isEqualTo: shortUrl)
        .limit(1)
        .get()
        .then(
          (snap) => snap.docs
              .map(
                (restaurant) => Restaurant.fromMap(
                  restaurant.id,
                  restaurant.data(),
                ),
              )
              .toList(),
        );
    if (restaurants.isEmpty) {
      return Restaurant.notFound();
    }

    return restaurants.first;
  }

  Future<Restaurant> getRestaurantById(String id) async {
    print(id);
    var request = _db.collection('restaurants').doc(id).get();
    return request.then(
      (snap) => Restaurant.fromMap(
        snap.id,
        snap.data() ?? {},
      ),
    );
  }

  Future<Restaurant> getRestaurantByEmail(String email) async {
    var request = _db.collection('restaurants');
    List<Restaurant> list = await request.get().then((snap) => snap.docs
        .map(
          (restaurant) => Restaurant.fromMap(
            restaurant.id,
            restaurant.data(),
          ),
        )
        .toList());

    Restaurant r = Restaurant.notFound();
    for (var i = 0; i < list.length; i++) {
      if (list.elementAt(i).emailUsers!.contains(email)) {
        r = list.elementAt(i);
        break;
      }
    }
    return r;
  }

  Stream<Restaurant> streamRestaurantById(String id) {
    return _db.collection('restaurants').doc(id).snapshots().map(
          (snap) => Restaurant.fromMap(
            snap.id,
            snap.data() ?? {},
          ),
        );
  }

  Stream<Restaurant> streamRestaurantByShortUrl(String shortUrl) {
    return _db
        .collection('restaurants')
        .where('shortUrl', isEqualTo: shortUrl)
        .snapshots()
        .map(
          (snap) => Restaurant.fromMap(
            snap.docs.first.id,
            snap.docs.first.data(),
          ),
        );
  }

  Stream<Guest> streamGuestById(String id) {
    return _db.collection('guests').doc(id).snapshots().map(
          (snap) => Guest.fromMap(
            snap.id,
            snap.data() ?? {},
          ),
        );
  }

  Future<Guest> getGuestById(String id) async {
    return _db.collection('guests').doc(id).get().then(
          // this can be null if the guest is not found
          // ignore: unnecessary_null_comparison
          (snap) => Guest.fromMap(
            snap.id,
            snap.data() ?? {},
          ),
        );
  }

  Future<void> create(String collectionName, MynuuModel object) async {
    _db.collection(collectionName).add(
          object.toMap(),
        );
  }

  Future<void> createWithId(
      String collectionName, String id, MynuuModel object) async {
    _db.collection(collectionName).doc(id).set(
          object.toMap(),
        );
  }

  Future<void> update({
    required String collectionName,
    required Map<String, dynamic> data,
    required String id,
  }) async {
    var ref = _db.collection(collectionName);
    await ref.doc(id).update(data);
    return;
  }

  Future<void> updateMany(
      {required String collectionName,
      required List<UpdateDto> updateDtos}) async {
    final batch = _db.batch();

    for (var item in updateDtos) {
      batch.update(_db.collection(collectionName).doc(item.id), item.data);
    }
    await batch.commit();

    return;
  }

  Future<void> delete({
    required String collectionName,
    required String documentId,
  }) async {
    return _db
        .collection(
          collectionName,
        )
        .doc(documentId)
        .delete();
  }
}

class UpdateDto {
  final Map<String, dynamic> data;
  final String id;

  UpdateDto(this.id, this.data);
}
