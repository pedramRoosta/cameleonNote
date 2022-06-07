import 'dart:developer';

import 'package:cameleon_note/helpers/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
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
        title: const Text('Login to your account'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
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
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    if (userCredential.user!.emailVerified) {
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     Routes.homeRoute, (route) => false);
                    } else {
                      // Navigator.of(context).pushNamed(Routes.verifyEmailRoute);
                    }
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'invalid-email':
                        log('Email is badly formatted!');
                        break;
                      case 'unknown':
                        log('Maybe your firebase console is not allowed the authentication!');
                        break;
                      case 'user-not-found':
                        log('User does not exist. Check your credentials.');
                        break;
                      default:
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                }
              },
              child: const Text('log in'),
            ),
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pushNamed(Routes.registerRoute);
                showAppDialog(message: 'A Simple Message', title: 'Warning');
              },
              child: const Text('Not yet registered? Register here.'),
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
