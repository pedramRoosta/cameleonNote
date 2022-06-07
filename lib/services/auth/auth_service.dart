import 'package:cameleon_note/services/auth/auth_user.dart';
import 'package:cameleon_note/services/auth/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<AuthUser> loginWithEmailandPassword({
    required String email,
    required String password,
  });
  Future<AuthUser> registerWithEmailandPassword({
    required String email,
    required String password,
  });
  Future<void> logout();

  Future<void> sendEmailVerification();

  AuthUser? get currentUser;
}

class AuthService implements IAuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AuthUser> registerWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (currentUser != null) {
        return currentUser!;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailIsInUsedAuthException();
        default:
          throw GeneralAuthException();
      }
    } catch (_) {
      throw GeneralAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firebaseAuth.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    if (_firebaseAuth.currentUser != null) {
      return AuthUser.fromUser(_firebaseAuth.currentUser!);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> loginWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (currentUser != null && currentUser!.isEmaiLVerified) {
        return currentUser!;
      } else {
        throw EmailNotVerifiedAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'unknown':
          throw GeneralAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GeneralAuthException();
      }
    } catch (e) {
      throw GeneralAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
