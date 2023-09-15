import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;
  const AuthUser({required this.isEmailVerified, this.email});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
      );
}
