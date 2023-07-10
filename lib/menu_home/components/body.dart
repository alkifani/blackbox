import 'package:bb/menu_home/components/home_header.dart';
import 'package:bb/size_config.dart';
import 'package:flutter/material.dart';


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(40)),
              const HomeHeader(),
              SizedBox(height: getProportionateScreenHeight(25)),
            ],
          ),
    ));
  }
}
