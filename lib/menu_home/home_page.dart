import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bb/autentikasi/login.dart';
import 'package:bb/daftar_perjalanan/daftar_perjalanan.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DocumentSnapshot> _documentFuture;
  String? emailValue;
  String? mulaiValue;
  int jumlahTrip = 0; // Variable to store the document count
  int totalPelanggaran = 0; // Variable to store the sum of 'pelanggaran' field
  bool isSendingLocation = false; // Flag to track GPS data sending status

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    final user = FirebaseAuth.instance.currentUser;
    _documentFuture = getDocument(user!.uid);
    listenToMulaiValueChanges();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  void listenToMulaiValueChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('IDAlat')
          .where('email', isEqualTo: user.email)
          .snapshots()
          .listen((snapshot) {
        try {
          if (snapshot.size > 0) {
            final document = snapshot.docs.first;
            setState(() {
              mulaiValue = document['mulai'] as String?;
            });
          }
        } catch (error) {
          print('Error listening to mulai value changes: $error');
        }
      });
    }
  }

  Future<DocumentSnapshot> getDocument(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Nama')
          .doc(userId)
          .get();
      return snapshot;
    } catch (error) {
      print('Error getting document: $error');
      rethrow;
    }
  }

  Future<void> LogOut() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('IDAlat')
          .where('email', isEqualTo: emailValue)
          .get();

      if (querySnapshot.size > 0) {
        // ID Alat sesuai dengan yang terdaftar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Log out'),
            content: const Text('Anda berhasil logout!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    jumlahTrip = 0;
                    totalPelanggaran = 0;
                  });
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.update({'kondisi': ''});
                    doc.reference.update({'email': ''});
                    doc.reference.update({'mulai': ''});
                  });
                  FirebaseAuth.instance.signOut();
                  // Navigate to the login screen or any other desired screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // ID Alat tidak sesuai
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal'),
            content: const Text('Anda gagal logout!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Penanganan kesalahan
      print('Error: $error');
    }
  }

  Future<int> getSumOfPelanggaran() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('DataPerjalanan')
        .where('email', isEqualTo: emailValue)
        .get();

    int count = 0;

    for (final doc in querySnapshot.docs) {
      final pelanggaran = doc['pelanggaran'] as Map<dynamic, dynamic>?;

      if (pelanggaran != null) {
        count += pelanggaran.length;
      }
    }

    return count;
  }

  Future<void> mulaiState(String state) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('IDAlat')
        .where('email', isEqualTo: emailValue)
        .get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.update({'mulai': state});
    });
  }

  Future<int> getCountOfDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('DataPerjalanan')
        .where('email', isEqualTo: emailValue)
        .get();
    return querySnapshot.docs.length;
  }

  Future<void> sendLocationDataToFirestore() async {
    final geolocator = GeolocatorPlatform.instance;

    try {
      // Check location permission
      LocationPermission permission = await geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, request permission from user
        permission = await geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission not granted, show a dialog to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Location Permission'),
              content: const Text('Location permission not granted.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }

      // Get current location
      Position? currentPosition = await geolocator.getCurrentPosition();

      // Send location data to Firestore
      if (currentPosition != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final latitude = currentPosition.latitude;
          final longitude = currentPosition.longitude;
          final speed = currentPosition.speed;
          final timestamp = DateTime.now();
          final geoPoint = GeoPoint(latitude, longitude);
          print(geoPoint);
          await FirebaseFirestore.instance.collection('data_gps').add({
            'email': user.email,
            'gpsperdetik': geoPoint,
            'speed': speed,
            'timestamp': timestamp,
          });
          print('Location data sent successfully.');
        }
      } else {
        print('Unable to get current location.');
      }
    } catch (error) {
      // Error handling
      print('Error sending location data: $error');
    }
  }

  Future<void> stopSendingLocationDataToFirestore() async {
    // Set the flag to stop sending location data
    setState(() {
      isSendingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _documentFuture,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final document = snapshot.data!;
              final namaValue = document['nama'] as String?;
              emailValue = document['email'] as String?; // Assign value to emailValue

              if (emailValue != null) {
                getCountOfDocuments().then((count) {
                  setState(() {
                    jumlahTrip = count;
                  });
                });

                getSumOfPelanggaran().then((sum) {
                  setState(() {
                    totalPelanggaran = sum;
                  });
                });
              }

              return Column(
                children: [
                  if (namaValue != null)
                    Text('Welcome to the Home Page, $namaValue!'),
                  if (emailValue != null) Text('Your email is: $emailValue'),
                  Text('Jumlah Trip: $jumlahTrip'),
                  Text('Total Pelanggaran: $totalPelanggaran'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DaftarPerjalanan(emailUser: emailValue!),
                        ),
                      );
                    },
                    child: Text("Data Perjalanan"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (mulaiValue == '') {
                        // Start functionality
                        mulaiState("1");
                        setState(() {
                          isSendingLocation = true;
                        });
                        while (mulaiValue == '1') {
                          listenToMulaiValueChanges();
                          sendLocationDataToFirestore();
                        }
                      } else if (mulaiValue == '1') {
                        // Stop functionality
                        mulaiState("");
                        stopSendingLocationDataToFirestore();
                      }
                    },
                    child: Text(mulaiValue == '' ? 'Mulai' : 'Stop'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LogOut();
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            } else {
              return Text('Welcome to the Home Page!');
            }
          },
        ),
      ),
    );
  }
}
