import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bb/id_alat/auth_alat.dart';

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
      Navigator.pushNamed(
        context,
        IdAlat.routeName,
        arguments: {'email': widget.email},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text('Welcome ${widget.email} To CO-SENSE APP'),
      ),
    );
  }
}
