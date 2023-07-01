import 'package:bb/autentikasi/login.dart';
import 'package:bb/bluetooth/konfigurasi_bluetooth.dart';
import 'package:bb/id_alat/auth_alat.dart';
import 'package:bb/menu_autentikasi.dart';
import 'package:bb/menu_home/home_page.dart';
import 'package:flutter/widgets.dart';

import 'package:bb/logo_app.dart';

final Map<String, WidgetBuilder> routes = {
  LogoApp.routeName: (context) => LogoApp(),
  LoginScreen.routeName: (context) => LoginScreen(),
  IdAlat.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String;
    return IdAlat(email: email);
  },
  HomePage.routeName: (context) => HomePage(),
  MenuAutentikasi.routeName: (context) => MenuAutentikasi(),
  KonfigurasiBluetooth.routeName: (context) => KonfigurasiBluetooth(),
};
