import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final menuEntries = <String>['Logout'];
  final _navService = locateService<INavService>();
  final _authService = locateService<IAuthService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_createPopupMenuButton()],
        title: const Text('Home page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Sacreen'),
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

  Widget _createPopupMenuButton() {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return menuEntries
            .map(
              (e) => PopupMenuItem<String>(
                value: e,
                child: Text(e),
                onTap: () async {
                  switch (e) {
                    case 'Logout':
                      await _authService.logout();
                      _navService.pushAndPopUntil(route: const LoginRoute());
                  }
                },
              ),
            )
            .toList();
      },
    );
  }
}
