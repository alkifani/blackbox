import 'package:bb/menu_home/components/body.dart';
import 'package:flutter/material.dart';


class HalamanUtama extends StatefulWidget {
  static const routeName = "/HalamanUtama";

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Body(),
    );
  }
}
