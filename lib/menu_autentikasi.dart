import 'package:bb/bluetooth/konfigurasi_bluetooth.dart';
import 'package:bb/menu_home/home_page.dart';
import 'package:flutter/material.dart';


class MenuAutentikasi extends StatefulWidget {
  static const routeName = "/MenuAutentikasi";

  @override
  State<MenuAutentikasi> createState() => _MenuAutentikasiState();
}

class _MenuAutentikasiState extends State<MenuAutentikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "INVERTING",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              "Selamat datang di Aplikasi INVERTING \nKami akan merating otomatis driver Anda !",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, KonfigurasiBluetooth.routeName);
              },
              child: const Text('Koneksi Bluetooth'),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, HomePage.routeName);
            },
                child: Text('Data Perjalanan')),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
