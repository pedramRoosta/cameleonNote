import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Screen'),
          TextButton(
            onPressed: () async {
              final approuter = getIt<INavService>();
              approuter.push(route: const LoginRoute());
            },
            child: const Text('Not yet registered? Register here.'),
          ),
        ],
      ),
    );
  }
}
