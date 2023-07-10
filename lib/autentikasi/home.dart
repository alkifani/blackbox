import 'dart:async';

import 'package:flutter/services.dart'; // Import package for platform-specific operations
import 'package:bb/menu_autentikasi.dart';
import 'package:flutter/material.dart';
// import 'package:bb/id_alat/auth_alat.dart';
// import 'package:bb/autentikasi/login.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      // Navigator.pushNamed(
      //   context,
      //   IdAlat.routeName,
      //   arguments: {'email': widget.email},
      // );
      // Navigator.pushNamed(context, MenuAutentikasi.routeName);
      Navigator.pushNamed(
        context,
        MenuAutentikasi.routeName,
        arguments: {'email': widget.email},
      );
      // Clear the navigation history up to this point
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Center(
        child: Text('Welcome ${widget.email} To INVERTING APP'),
      ),
    );
  }
}
