// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter/material.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'app.dart' as _i7;
import 'services/auth/auth_service.dart' as _i4;
import 'services/router/nav_service.dart' as _i5;
import 'services/router/routes.dart' as _i3;
import 'setup.dart' as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppRoute>(registerModule.appRoute);
  gh.singleton<_i4.IAuthService>(registerModule.authService);
  gh.singleton<_i5.INavService>(registerModule.navService);
  gh.factory<_i6.Key>(() => registerModule.key);
  gh.factory<_i7.App>(
      () => _i7.App(appRoute: get<_i3.AppRoute>(), key: get<_i6.Key>()));
  return get;
}

class _$RegisterModule extends _i8.RegisterModule {
  @override
  _i6.UniqueKey get key => _i6.UniqueKey();
}
