import 'package:flutter/material.dart';

class AmbilData extends StatefulWidget {
  @override
  State<AmbilData> createState() => _AmbilDataState();
}

class _AmbilDataState extends State<AmbilData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      appBar: AppBar(
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text('Upload Data'),
        )),
        backgroundColor: Color.fromRGBO(0, 28, 48, 0.5),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color here
          size: 30, // Change the size here
        ),
      ),
      body: Center(
        child: Text(
          'This is an empty Flutter page.',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}