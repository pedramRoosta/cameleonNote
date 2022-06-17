import 'package:auto_route/auto_route.dart';
import 'package:cameleon_note/screens/note/new_note.dart';

import 'package:cameleon_note/screens/note/notes.dart';
import 'package:cameleon_note/screens/login.dart';
import 'package:cameleon_note/screens/register.dart';
import 'package:cameleon_note/screens/verify_email.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:flutter/material.dart';

part 'routes.gr.dart';

abstract class Routes {
  static const String noteRoute = '/';
  static const String loginRoute = '/login';
  static const String verifyEmailRoute = '/verifyEmail';
  static const String registerRoute = '/register';
  static const String newNoteRoute = '/new_note';
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
      page: NotesScreen,
      path: Routes.noteRoute,
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
    ),
    AutoRoute(
      page: EditNoteScreen,
      path: Routes.newNoteRoute,
      guards: [AuthGuard],
    )
  ],
)
class AppRoute extends _$AppRoute {
  AppRoute({required super.authGuard});
}
