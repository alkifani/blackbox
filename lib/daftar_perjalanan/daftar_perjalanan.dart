import 'package:flutter/material.dart';
import 'package:bb/daftar_perjalanan/detail_perjalanan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DaftarPerjalanan extends StatefulWidget {
  final String emailUser;

  DaftarPerjalanan({required this.emailUser});

  @override
  State<DaftarPerjalanan> createState() => _DaftarPerjalananState();
}

class _DaftarPerjalananState extends State<DaftarPerjalanan> {
  late Stream<QuerySnapshot> _documentsStream;

  @override
  void initState() {
    super.initState();
    _documentsStream = FirebaseFirestore.instance
        .collection('DataPerjalanan')
        .where('email', isEqualTo: widget.emailUser)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Perjalanan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _documentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                final documentData = document.data() as Map<String, dynamic>;
                final documentId = document.id;
                final timestamp = documentData['datetime'] as Timestamp;
                final tanggal = DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
                final rate = documentData['rate'];

                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return DetailPerjalanan(idPerjalanan: documentId);
                    }));
                  },
                  child: ListTile(
                    title: Text(tanggal),
                    subtitle: Text(rate),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text('No documents found.'),
          );
        },
      ),
    );
  }
}
