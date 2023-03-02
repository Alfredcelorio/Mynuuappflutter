import 'package:meta/meta.dart';

@immutable
class FirebaseUser {
  FirebaseUser({
    required this.uid,
    required this.email,
    this.photoUrl,
    this.displayName,
    required this.isVerified,
    this.isNew = false,
    required this.providerId,
  });

  String uid;
  final String email;
  final String? photoUrl;
  final String? displayName;
  final bool isVerified;
  final bool isNew;
  final String? providerId;

  FirebaseUser.notFound()
      : uid = 'notFound',
        email = '',
        photoUrl = '',
        displayName = '',
        isVerified = false,
        isNew = false,
        providerId = '';
}
