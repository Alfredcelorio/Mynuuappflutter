import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/common/models/mynuu_model.dart';

class Guest extends MynuuModel {
  Timestamp? firstVisit;
  Timestamp? lastVisit;
  DateTime? birthdate;
  final String id;

  String name;
  final String email;
  final String? phone;
  String restaurantId;
  final bool vip;
  final bool blacklisted;
  String signInType;
  int? numberOfVisits;
  List<dynamic>? listNotes;
  List<dynamic>? likeProducts;
  Guest(
      {required this.firstVisit,
      required this.lastVisit,
      required this.id,
      required this.name,
      required this.email,
      required this.restaurantId,
      required this.vip,
      required this.blacklisted,
      required this.signInType,
      this.numberOfVisits,
      this.birthdate,
      this.phone,
      this.listNotes,
      this.likeProducts});

  factory Guest.fromMap(String id, Map<String, dynamic> data) {
    print(data);
    return Guest(
        id: id,
        firstVisit: data['firstVisit'] != null && data['firstVisit'] != ''
            ? data['firstVisit']
            : null,
        lastVisit: data['lastVisit'] != null && data['lastVisit'] != ''
            ? data['lastVisit']
            : null,
        birthdate: data['birthdate'] != null && data['birthdate'] != ''
            ? (data['birthdate'] as Timestamp).toDate()
            : null,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'],
        restaurantId: data['restaurantId'] ?? '',
        vip: data['vip'] ?? false,
        blacklisted: data['blacklisted'] ?? false,
        signInType: data['signInType'] ?? '',
        listNotes:
            data['listNotes'] != null ? data['listNotes'] as List<dynamic> : [],
        likeProducts: data['likeProducts'] != null
            ? data['likeProducts'] as List<dynamic>
            : [],
        numberOfVisits: data['numberOfVisits'] ?? 0);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'firstVisit': firstVisit,
      'lastVisit': lastVisit,
      'name': name,
      'email': email,
      'phone': phone,
      'restaurantId': restaurantId,
      'vip': vip,
      'blacklisted': blacklisted,
      'signInType': signInType,
      'birthdate': birthdate,
      'numberOfVisits': numberOfVisits,
      'listNotes': listNotes,
      'likeProducts': likeProducts
    };
  }

  copyWith(
      {Timestamp? firstVisit,
      Timestamp? lastVisit,
      String? id,
      String? name,
      String? email,
      String? phone,
      String? restaurantId,
      bool? vip,
      bool? blacklisted,
      String? signInType,
      int? numberOfVisits,
      List<dynamic>? listNotes,
      List<dynamic>? likeProducts,
      DateTime? birthdate}) {
    return Guest(
        firstVisit: firstVisit ?? this.firstVisit,
        lastVisit: lastVisit ?? this.lastVisit,
        birthdate: birthdate ?? this.birthdate,
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        restaurantId: restaurantId ?? this.restaurantId,
        vip: vip ?? this.vip,
        blacklisted: blacklisted ?? this.blacklisted,
        signInType: signInType ?? this.signInType,
        listNotes: listNotes ?? this.listNotes,
        likeProducts: likeProducts ?? this.likeProducts,
        numberOfVisits: numberOfVisits ?? this.numberOfVisits);
  }
}
