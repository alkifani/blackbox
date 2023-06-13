import 'package:bb/autentikasi/components/login.dart';
import 'package:bb/id_alat/auth_alat.dart';
import 'package:bb/menu_home/home_page.dart';
import 'package:flutter/widgets.dart';

import 'package:bb/logo_app.dart';

final Map<String, WidgetBuilder> routes = {
  // SplashScreen.routeName: (context) => SplashScreen(),
  LogoApp.routeName: (context) => LogoApp(),
  LoginScreen.routeName: (context) => LoginScreen(),
  IdAlat.routeName: (context) => IdAlat(),
  HomePage.routeName: (context) => HomePage(),
};