import 'package:flutter/material.dart';
import 'package:movie/config/application.dart';
import 'package:movie/config/routes/routes_const.dart';
import 'package:movie/const/app_constants.dart';
import 'package:movie/screens/authentication/screens/login.dart';
import 'package:movie/screens/home/screens/home_screen.dart';

import 'package:movie/splash.dart';

class AppRouteSetting {
  static AppRouteSetting? _routeSetting;

  AppRouteSetting._internal();

  static AppRouteSetting? getInstance() {
    _routeSetting ??= AppRouteSetting._internal();
    return _routeSetting;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case AppRoutes.home:
        Object? arguments = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => HomeScreenDisplay(
            currentIndex:
                (arguments is Map ? (arguments["index"] ?? 0) as int : 0),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Center(child: Text("Hi There")),
        );
    }
  }
}
