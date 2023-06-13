import 'package:flutter/material.dart';
// import 'package:bb/logo_app.dart';
// import 'package:bb/menu_home/home_page.dart';
// import 'package:bb/size_config.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


class IdAlat extends StatefulWidget {
  static const routeName = "/IdAlat";

  @override
  State<IdAlat> createState() => _IdAlatState();
}

class _IdAlatState extends State<IdAlat> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selamat Datang Di Aplikasi CO-SENSE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              "Silahkan Masukkan ID Alat Black Box Anda \nYang Telah Terdata Pada Sistem!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                // controller: _emailController,
                decoration: const InputDecoration(hintText: 'ID Alat Black Box'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                // Mengirim data ke Firestore
                // await firestore.collection('nama_collection').add({
                //   'email': _emailController.text,
                //   'password': _passwordController.text,
                // });

                // final message = await HomePage());
                // if (message!.contains('Success')) {
                //   Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(
                //       builder: (context) => HomePage(),
                //     ),
                //   );
                // }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(message),
                //   ),
                // );
              },
              child: const Text('Hubungkan'),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
