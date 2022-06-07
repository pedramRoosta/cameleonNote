import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool isEmaiLVerified;

  AuthUser(this.isEmaiLVerified);

  factory AuthUser.fromUser(User user) {
    return AuthUser(user.emailVerified);
  }
}
