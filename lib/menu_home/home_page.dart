import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bb/autentikasi/components/login.dart';
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

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _documentFuture = getDocument(user!.uid);
    listenToMulaiValueChanges();
  }

  void listenToMulaiValueChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('IDAlat')
          .where('email', isEqualTo: user.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.size > 0) {
          final document = snapshot.docs.first;
          setState(() {
            mulaiValue = document['mulai'] as String?;
          });
        }
      });
    }
  }

  Future<DocumentSnapshot> getDocument(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Nama')
        .doc(userId)
        .get();
    return snapshot;
  }

  Future<int> getCountOfDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('DataPerjalanan')
        .where('email', isEqualTo: emailValue)
        .get();
    return querySnapshot.docs.length;
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
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginScreen()), (Route<dynamic> route) => false);
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

  Future<void> mulaiState(String state) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('IDAlat')
        .where('email', isEqualTo: emailValue)
        .get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.update({'mulai': state});
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
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                  if (emailValue != null)
                    Text('Your email is: $emailValue'),
                  Text('Jumlah Trip: $jumlahTrip'),
                  Text('Total Pelanggaran: $totalPelanggaran'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DaftarPerjalanan(emailUser: emailValue!,)),
                      );
                    },
                    child: Text("Data Perjalanan"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (mulaiValue == '') {
                        // Start functionality
                        mulaiState("1");
                      } else if (mulaiValue == '1') {
                        // Stop functionality
                        mulaiState("");
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
