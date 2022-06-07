// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'routes.dart';

class _$AppRoute extends RootStackRouter {
  _$AppRoute({GlobalKey<NavigatorState>? navigatorKey, required this.authGuard})
      : super(navigatorKey);

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const LoginScreen());
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomeScreen());
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RegisterScreen());
    },
    VerifyEmailRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const VerifyEmailScreen());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(LoginRoute.name, path: '/login'),
        RouteConfig(HomeRoute.name, path: '/', guards: [authGuard]),
        RouteConfig(RegisterRoute.name, path: '/register'),
        RouteConfig(VerifyEmailRoute.name,
            path: '/verifyEmail', guards: [authGuard])
      ];
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: '/register');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [VerifyEmailScreen]
class VerifyEmailRoute extends PageRouteInfo<void> {
  const VerifyEmailRoute() : super(VerifyEmailRoute.name, path: '/verifyEmail');

  static const String name = 'VerifyEmailRoute';
}
