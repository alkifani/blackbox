// import 'package:bb/autentikasi/auth_screen.dart';
import 'package:bb/autentikasi/components/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bb/routes.dart';

class LogoApp extends StatefulWidget {
  static const routeName = "/Logo_App";

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Color(0xFF6C6C6C),
        child: Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
