import 'package:cameleon_note/services/auth/auth_service.dart';
import 'package:cameleon_note/services/cloud/firebase_cloud_storage.dart';
import 'package:cameleon_note/services/repository/repository_service.dart';
import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/services/router/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:cameleon_note/setup.config.dart';

final getIt = GetIt.instance;
T locateService<T extends Object>() => getIt.get<T>();
@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

@module
abstract class RegisterModule {
  @Injectable(as: Key)
  UniqueKey get key;

  @singleton
  IAuthService get authService =>
      AuthService(firebaseAuth: FirebaseAuth.instance);

  final _appRouter = AppRoute(authGuard: AuthGuard());

  @singleton
  AppRoute get appRoute => _appRouter;

  @singleton
  INavService get navService => NavService(approuter: _appRouter);

  @singleton
  Repository get repoService => Repository();

  @singleton
  FirebaseCloudStorage get cloudService => FirebaseCloudStorage();
}
