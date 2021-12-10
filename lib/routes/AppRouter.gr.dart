// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/cupertino.dart' as _i4;
import 'package:flutter/material.dart' as _i3;

import '../splashscreen/splash_screen.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i3.GlobalKey<_i3.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SplashScreenRouteArgs>(
          orElse: () => const SplashScreenRouteArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SplashScreenPage(key: args.key));
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i2.RouteConfig(SplashScreenRoute.name, path: '/splash', children: [
          _i2.RouteConfig('*#redirect',
              path: '*',
              parent: SplashScreenRoute.name,
              redirectTo: '',
              fullMatch: true)
        ])
      ];
}

/// generated route for [_i1.SplashScreenPage]
class SplashScreenRoute extends _i2.PageRouteInfo<SplashScreenRouteArgs> {
  SplashScreenRoute({_i4.Key? key, List<_i2.PageRouteInfo>? children})
      : super(name,
            path: '/splash',
            args: SplashScreenRouteArgs(key: key),
            initialChildren: children);

  static const String name = 'SplashScreenRoute';
}

class SplashScreenRouteArgs {
  const SplashScreenRouteArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'SplashScreenRouteArgs{key: $key}';
  }
}
