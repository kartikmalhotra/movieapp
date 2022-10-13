import 'package:flutter/material.dart';
import 'package:movie/config/application.dart';
import 'package:movie/config/routes/routes_const.dart';
import 'package:movie/config/theme/theme_config.dart';

class SplashScreen extends StatefulWidget {
  final bool isFromQuickAction;

  const SplashScreen({Key? key, this.isFromQuickAction = false})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (AppUser.isLoggedIn ?? false) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, ((route) => false));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.login, ((route) => false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          "MOVIE",
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
