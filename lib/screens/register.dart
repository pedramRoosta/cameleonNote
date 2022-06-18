import 'dart:developer';

import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  final _navService = locateService<INavService>();

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _emailCtrl.text = 'pedram.post@gmail.com';
    _passwordCtrl.text = 'wwwwww';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register page'),
      ),
      body: Container(
        margin: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _emailCtrl,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _passwordCtrl,
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _emailCtrl.text;
                final password = _passwordCtrl.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password)
                        .then(
                      (value) async {
                        await FirebaseAuth.instance.currentUser!
                            .sendEmailVerification()
                            .then((value) => log('email has been sent kako'));
                      },
                    );
                    _navService.push(route: const VerifyEmailRoute());
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'invalid-email':
                        log('Email is badly formatted!');
                        break;
                      case 'unknown':
                        log('Maybe your firebase console is not allowed the authentication!');
                        break;
                      case 'weak-password':
                        log('The provided password is weak!');
                        break;
                      case 'email-already-in-use':
                        log('The email has already been used. please use another credentials');
                        break;
                      default:
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () async {
                _navService.pushAndPopUntil(route: const LoginRoute());
              },
              child: const Text('Already registered? login here.'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }
}
