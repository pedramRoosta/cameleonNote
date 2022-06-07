import 'package:auto_route/auto_route.dart';

import 'package:cameleon_note/screens/home.dart';
import 'package:cameleon_note/screens/login.dart';
import 'package:cameleon_note/screens/register.dart';
import 'package:cameleon_note/screens/verify_email.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:flutter/material.dart';

part 'routes.gr.dart';

abstract class Routes {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String verifyEmailRoute = '/verifyEmail';
  static const String registerRoute = '/register';
}

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: LoginScreen,
      path: Routes.loginRoute,
    ),
    AutoRoute(
      initial: true,
      page: HomeScreen,
      path: Routes.homeRoute,
      guards: [AuthGuard],
    ),
    AutoRoute(
      page: RegisterScreen,
      path: Routes.registerRoute,
    ),
    AutoRoute(
      page: VerifyEmailScreen,
      path: Routes.verifyEmailRoute,
      guards: [AuthGuard],
    )
  ],
)
class AppRoute extends _$AppRoute {
  AppRoute({required super.authGuard});
}
