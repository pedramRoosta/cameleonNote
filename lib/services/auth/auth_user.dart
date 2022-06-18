import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool isEmaiLVerified;
  final String email;
  final String id;

  AuthUser(
      {required this.id, required this.isEmaiLVerified, required this.email});

  factory AuthUser.fromUser(User user) {
    return AuthUser(
      id: user.uid,
      isEmaiLVerified: user.emailVerified,
      email: user.email!,
    );
  }
}
