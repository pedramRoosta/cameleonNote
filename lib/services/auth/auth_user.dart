import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool isEmaiLVerified;
  final String email;

  AuthUser({required this.isEmaiLVerified, required this.email});

  factory AuthUser.fromUser(User user) {
    return AuthUser(
      isEmaiLVerified: user.emailVerified,
      email: user.email!,
    );
  }
}
