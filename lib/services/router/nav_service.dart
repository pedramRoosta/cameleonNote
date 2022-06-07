import 'package:auto_route/auto_route.dart';
import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/cupertino.dart';

abstract class INavService {
  void pop();
  void push({required PageRouteInfo<dynamic> route});
  BuildContext? get currentContext;
}

class NavService implements INavService {
  NavService({
    required AppRoute approuter,
  }) : _approuter = approuter;

  final AppRoute _approuter;

  @override
  void pop() {
    AutoRouter.of(currentContext!).pop();
  }

  @override
  void push({required PageRouteInfo<dynamic> route}) {
    AutoRouter.of(currentContext!).push(route);
  }

  @override
  BuildContext? get currentContext => _approuter.navigatorKey.currentContext;
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = locateService<IAuthService>();
    if (authService.currentUser != null) {
      resolver.next(true);
    } else {
      router.pushAndPopUntil(const LoginRoute(), predicate: (_) => false);
    }
  }
}
