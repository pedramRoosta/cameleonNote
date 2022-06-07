import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

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
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     Routes.loginRoute, (route) => false);
              },
              child: const Text('Verified? Log in here'),
            ),
          ],
        ),
      ),
    );
  }
}
