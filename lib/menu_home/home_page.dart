import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DocumentSnapshot> _documentFuture;
  String? emailValue;
  int jumlahTrip = 0; // Variable to store the document count
  int totalPelanggaran = 0; // Variable to store the sum of 'pelanggaran' field

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _documentFuture = getDocument(user!.uid);
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
                  if (snapshot.connectionState == ConnectionState.done)
                    Text('Sum of Pelanggaran: $totalPelanggaran'),
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




