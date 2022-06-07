import 'package:cameleon_note/services/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class App extends StatelessWidget {
  const App({
    required AppRoute appRoute,
    Key? key,
  })  : _appRoute = appRoute,
        super(key: key);

  final AppRoute _appRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRoute.delegate(),
      routeInformationParser: _appRoute.defaultRouteParser(),
    );
  }
}
