import 'package:bb/bluetooth/konfigurasi_bluetooth.dart';
import 'package:bb/menu_home/home_page.dart';
import 'package:bb/menu_home/menu_utama.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bb/autentikasi/login.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // Import package for platform-specific operations


class MenuAutentikasi extends StatefulWidget {
  static const routeName = "/MenuAutentikasi";

  @override
  State<MenuAutentikasi> createState() => _MenuAutentikasiState();
}

class _MenuAutentikasiState extends State<MenuAutentikasi> {
  String? mulaiValue;
  bool? isSendingLocation;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    // listenToMulaiValueChanges();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> mulaiState(String state) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('IDAlat')
        .where('email', isEqualTo: user!.email)
        .get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.update({'mulai': state});
    });
  }

  // void listenToMulaiValueChanges() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     FirebaseFirestore.instance
  //         .collection('IDAlat')
  //         .where('email', isEqualTo: user.email)
  //         .snapshots()
  //         .listen((snapshot) {
  //       try {
  //         if (snapshot.size > 0) {
  //           final document = snapshot.docs.first;
  //           setState(() {
  //             mulaiValue = document['mulai'] as String?;
  //           });
  //
  //           // Start sending location data if mulaiValue is "1"
  //           if (mulaiValue == '1') {
  //             sendLocationDataToFirestore();
  //             setState(() {
  //               isSendingLocation = true;
  //             });
  //           } else {
  //             setState(() {
  //               isSendingLocation = false;
  //             });
  //             stopSendingLocationDataToFirestore();
  //           }
  //         }
  //       } catch (error) {
  //         print('Error listening to mulai value changes: $error');
  //       }
  //     });
  //   }
  // }
  //
  // // Future<void> sendLocationDataToFirestore() async {
  // //   final geolocator = GeolocatorPlatform.instance;
  // //
  // //   try {
  // //     // Check location permission
  // //     LocationPermission permission = await geolocator.checkPermission();
  // //     if (permission == LocationPermission.denied) {
  // //       // Permission denied, request permission from user
  // //       permission = await geolocator.requestPermission();
  // //       if (permission == LocationPermission.denied) {
  // //         // Permission not granted, show a dialog to the user
  // //         showDialog(
  // //           context: context,
  // //           builder: (context) => AlertDialog(
  // //             title: const Text('Location Permission'),
  // //             content: const Text('Location permission not granted.'),
  // //             actions: [
  // //               TextButton(
  // //                 onPressed: () => Navigator.pop(context),
  // //                 child: const Text('OK'),
  // //               ),
  // //             ],
  // //           ),
  // //         );
  // //         return;
  // //       }
  // //     }
  // //
  // //     // Get current location
  // //     Position? currentPosition = await geolocator.getCurrentPosition();
  // //
  // //     // Send location data to Firestore
  // //     if (currentPosition != null) {
  // //       final user = FirebaseAuth.instance.currentUser;
  // //       if (user != null) {
  // //         final latitude = currentPosition.latitude;
  // //         final longitude = currentPosition.longitude;
  // //         final speedMS = currentPosition.speed; // Speed in meters per second
  // //         final speedKMH = (speedMS * 3.6).roundToDouble(); // Convert speed to km/h
  // //         final timestamp = DateTime.now();
  // //         final geoPoint = GeoPoint(latitude, longitude);
  // //         print(geoPoint);
  // //         final querySnapshot = await FirebaseFirestore.instance
  // //             .collection('IDAlat')
  // //             .where('email', isEqualTo: user!.email)
  // //             .get();
  // //
  // //         querySnapshot.docs.forEach((doc) {
  // //           doc.reference.update({'gpsperdetik': geoPoint});
  // //           doc.reference.update({'speed': speedKMH});
  // //           doc.reference.update({'timestamp': timestamp});
  // //         });
  // //
  // //         print('Location data sent successfully.');
  // //       }
  // //     } else {
  // //       print('Unable to get current location.');
  // //     }
  // //   } catch (error) {
  // //     // Error handling
  // //     print('Error sending location data: $error');
  // //   }
  // // }


  Future<void> stopSendingLocationDataToFirestore() async {
    // Set the flag to stop sending location data
    setState(() {
      isSendingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              children: <Widget>[
                const SizedBox(
                  height: 91.0,
                ),

                Text(
                  "INVERTING",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 13.0,
                ),

                const Text(
                  "Selamat datang di Aplikasi INVERTING",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(
                  height: 15.0,
                ),

                const Text(
                  "Kami Akan Rating Otomatis Driver Anda !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            Column(
              children: <Widget>[
                SizedBox(
                  height: 61,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, KonfigurasiBluetooth.routeName);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the corner radius as desired
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(218, 255, 251, 1), // Red color (RGB: 255, 0, 0)
                      ),
                    ),
                    child: const Text('KONEKSI BLUETOOTH', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black54),),
                  ),
                ),

                const SizedBox(
                  height: 30.0,
                ),

                SizedBox(
                  height: 61,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, HomePage.routeName);
                      Navigator.pushNamed(context, HalamanUtama.routeName);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the corner radius as desired
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(218, 255, 251, 1), // Red color (RGB: 255, 0, 0)
                      ),
                    ),
                    child: const Text('DATA PERJALANAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black54),),
                  ),
                ),

                const SizedBox(
                  height: 30.0,
                ),

                SizedBox(
                  height: 61,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                      // Clear the navigation history up to this point
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the corner radius as desired
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(218, 255, 251, 1), // Red color (RGB: 255, 0, 0)
                      ),
                    ),
                    child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black54),),
                  ),
                ),

                const SizedBox(
                  height: 67.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
