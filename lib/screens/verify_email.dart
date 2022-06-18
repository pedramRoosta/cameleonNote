import 'dart:developer';

import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  VerifyEmailScreen({Key? key}) : super(key: key);

  final _navService = locateService<INavService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
      ),
      body: Container(
        margin: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'An verify message has been send to your email. please open your mail and click on the link to activate your account.'),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (!user.emailVerified) {
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();
                    log('please check your inbox !');
                  } else {
                    log('Your email is verified. please log in');
                  }
                } else {
                  log('User does not exist, please register befor trying to log in.');
                }
              },
              child: const Text('Resend the activation link.'),
            ),
            TextButton(
              onPressed: () async {
                _navService.pushAndPopUntil(route: const LoginRoute());
              },
              child: const Text('Verified? Log in here'),
            ),
          ],
        ),
      ),
    );
  }
}
