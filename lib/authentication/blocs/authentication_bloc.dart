import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/authentication/services/auth_service.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/services/landing_service.dart';
import 'package:project1/common/services/push_notification_service.dart';

class AuthenticationBLoc {
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> uploadLogoCompleted = ValueNotifier(false);
  ValueNotifier<List<Map<String, String>>> idsR = ValueNotifier([]);
  final storage = FirebaseStorage.instance;

  ValueNotifier<bool> skipToUploadLogo = ValueNotifier(false);

  final AuthService auth;
  final CloudFirestoreService databaseService;
  final PushNotificationProvider pushNotificationProvider;

  Restaurant? currentRestaurant;
  String? currentUserId;

  AuthenticationBLoc({
    required this.auth,
    required this.databaseService,
    required this.pushNotificationProvider,
  });

  Future<void> signOut() async {
    final token = await pushNotificationProvider.getUserToken();
    final firebaseUser = await auth.currentUser();
    currentUserId = firebaseUser!.uid;
    final currentUser =
        await databaseService.getRestaurantById(currentUserId ?? '');
    if (currentUser.notificationTokens.contains(token)) {
      currentUser.notificationTokens.remove(token);
      await databaseService.update(
        collectionName: 'restaurants',
        data: currentUser.toMap(),
        id: currentUser.id,
      );
    }

    await auth.signOut();
  }

  Stream<FirebaseUser?> get onAuthStateChanged => auth.onAuthStateChanged;

  Future<FirebaseUser> _signIn(
      Future<FirebaseUser?> Function() signInMethod) async {
    try {
      loading.value = true;
      FirebaseUser? _user = await signInMethod();

      if (_user != null) {
        // Let's evaluate if the profile already exist.
        currentRestaurant = await databaseService.getRestaurantById(_user.uid);
        if (currentRestaurant == null) {
          await _createFirestoreUser(
            id: _user.uid,
            email: _user.email,
            photoUrl: '',
            restaurantName: 'Restaurant 1',
            ownerName: _user.displayName ?? 'Mynuu User',
          );
          currentRestaurant = await databaseService.getRestaurantById(
            _user.uid,
          );
        }
        updatePushNotificationToken(currentRestaurant!);
        currentUserId = _user.uid;
        return _user;
      } else {
        throw Exception('No user');
      }
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      return await _signIn(auth.signInWithGoogle);
    } catch (e) {
      rethrow;
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    try {
      return await _signIn(auth.signInWithFacebook);
    } catch (e) {
      rethrow;
    }
  }

  Future<FirebaseUser> signInWithApple() async {
    try {
      return await _signIn(auth.signInWithApple);
    } catch (e) {
      rethrow;
    }
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      loading.value = true;

      FirebaseUser? userLogged =
          await auth.signInWithEmailAndPassword(email, password);
      if (userLogged != null) {
        currentUserId = userLogged.uid;
        currentRestaurant =
            await databaseService.getRestaurantById(userLogged.uid);
        if (currentRestaurant == null) {
          throw Exception('No user');
        }
        if (currentRestaurant!.shortUrl!.isEmpty) {
          final resp = await databaseService.getGuestByAdmin(userLogged.email);
          currentRestaurant = await databaseService
              .getRestaurantById(resp[0]['idR'] != null ? resp[0]['idR']! : '');
        }
        updatePushNotificationToken(currentRestaurant!);
        return userLogged;
      } else {
        throw Exception('No user found');
      }
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    loading.value = true;
    await auth.sendPasswordResetEmail(email);
    loading.value = false;
  }

  /// Creating a new user with [email] and [password]
  /// further with add the [username] on Cloud Firestore
  Future<FirebaseUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String restaurantName,
    required String ownerName,
  }) async {
    try {
      loading.value = true;
      FirebaseUser? _user =
          await auth.createUserWithEmailAndPassword(email, password);
      if (_user != null) {
        await _createFirestoreUser(
            id: _user.uid,
            email: email,
            photoUrl:
                '', // First time no logo provided, it will come after this screen interaction
            restaurantName: restaurantName,
            ownerName: ownerName);
        return _user;
      } else {
        throw Exception('No user found');
      }
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> initializeRestaurant(String userId, String email) async {
    idsR.value = [];
    final restInvited = await databaseService.getGuestByAdmin(email);
    if (restInvited.isNotEmpty) {
      idsR.value = restInvited;
      currentRestaurant = await databaseService.getRestaurantById(
          idsR.value[0]['idR'] != null ? idsR.value[0]['idR']! : '');
    } else {
      idsR.value.add({'idR': '', 'nameR': '', 'rol': 'Manager', 'token': ''});
      currentRestaurant = await databaseService.getRestaurantById(userId);
    }

    return true;
  }

  Future<bool> uploadRestaurantLogo(File logo) async {
    loading.value = true;

    currentRestaurant ??=
        await databaseService.getRestaurantById(currentUserId!);

    final restaurant = currentRestaurant;
    if (restaurant != null) {
      final imageUrl = await _saveRestaurantLogoToFirestorage(
        file: logo,
        restaurantName: restaurant.restaurantName,
      );
      if (imageUrl.isNotEmpty) {
        restaurant.logo = imageUrl;
        await databaseService.update(
          collectionName: 'restaurants',
          data: restaurant.toMap(),
          id: restaurant.id,
        );
      }
      currentRestaurant!.logo = imageUrl;
      uploadLogoCompleted.value = true;
      loading.value = false;
      // upload successfully
      return true;
    }

    loading.value = false;
    // upload was not efectued
    return false;
  }

  Future<Restaurant> getRestaurantById(String id) async {
    return await databaseService.getRestaurantById(id);
  }

  Stream<Restaurant> streamRestaurantById(String id) {
    return databaseService.streamRestaurantById(id);
  }

  Future<void> registerGuest({
    required String id,
    required String email,
    required String name,
    required String restaurantId,
    required String signInType,
  }) async {
    // Check if the guest already exists
    var guest = await databaseService.getGuestById(id);
    if (guest.restaurantId != restaurantId) {
      guest = Guest(
        id: id,
        email: email,
        name: name,
        firstVisit: Timestamp.fromDate(
          DateTime.now(),
        ),
        lastVisit: Timestamp.fromDate(
          DateTime.now(),
        ),
        restaurantId: restaurantId,
        vip: false,
        blacklisted: false,
        signInType: signInType,
      );
    } else {
      guest.restaurantId = restaurantId;
      guest.signInType = signInType;
      guest.lastVisit = Timestamp.fromDate(
        DateTime.now(),
      );
    }

    await databaseService.createWithId('guests', guest.id, guest);
  }

  Future<void> registerOrUpdatePhoneGuest(
      {required String id,
      required String name,
      required String phoneNumber,
      required String restaurantId,
      DateTime? birthdate}) async {
    // Check if the guest already exists
    var guest = await databaseService.getGuestById(id);

    // First check if user has signed in with phone number before
    if (guest.phone == null || guest.phone!.isEmpty) {
      guest = Guest(
        id: id,
        phone: phoneNumber,
        email: '',
        name: name,
        firstVisit: Timestamp.fromDate(
          DateTime.now(),
        ),
        lastVisit: Timestamp.fromDate(
          DateTime.now(),
        ),
        restaurantId: restaurantId,
        birthdate: birthdate,
        vip: false,
        blacklisted: false,
        signInType: 'phone',
      );

      await databaseService.createWithId('guests', guest.id, guest);
    } else {
      guest.signInType = 'phone';
      guest.name = name;
      guest.lastVisit = Timestamp.fromDate(
        DateTime.now(),
      );
      await databaseService.update(
          collectionName: 'guests', data: guest.toMap(), id: guest.id);
    }
  }

  Future<void> _createFirestoreUser({
    required String id,
    required String email,
    required String photoUrl,
    required String restaurantName,
    required String ownerName,
  }) async {
    final token = await pushNotificationProvider.getUserToken();
    final restaurant = Restaurant(
      id: id,
      restaurantName: restaurantName,
      ownerName: ownerName,
      logo: photoUrl,
      landingImage: '',
      email: email,
      notificationTokens: [token],
    );

    await databaseService.createWithId(
        'restaurants', restaurant.id, restaurant);
  }

  Future<String> _saveRestaurantLogoToFirestorage({
    required File file,
    required String restaurantName,
  }) async {
    String downloadUrl = '';

    final mountainImagesRef =
        storage.ref().child("restaurants/$restaurantName.jpg");
    try {
      await mountainImagesRef.putFile(file);
      downloadUrl = await mountainImagesRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }

    return downloadUrl;
  }

  Future<void> updatePushNotificationToken(Restaurant userSession) async {
    final token = await pushNotificationProvider.getUserToken();
    if (userSession.notificationTokens.contains(token)) {
      return;
    }
    userSession.notificationTokens.add(token);
    await databaseService.update(
      collectionName: 'restaurants',
      data: userSession.toMap(),
      id: userSession.id,
    );
  }
}
