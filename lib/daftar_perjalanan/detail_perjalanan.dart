import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPerjalanan extends StatefulWidget {
  final String idPerjalanan;

  DetailPerjalanan({required this.idPerjalanan});

  @override
  State<DetailPerjalanan> createState() => _DetailPerjalananState();
}

class _DetailPerjalananState extends State<DetailPerjalanan> {
  late Stream<DocumentSnapshot> _documentStream;

  @override
  void initState() {
    super.initState();
    _documentStream = FirebaseFirestore.instance
        .collection('DataPerjalanan')
        .doc(widget.idPerjalanan)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Perjalanan'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _documentStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final documentData = snapshot.data!.data() as Map<String, dynamic>;
            final pelanggaranMap = documentData['pelanggaran'] as Map<String, dynamic>;

            return ListView.builder(
              itemCount: pelanggaranMap.length,
              itemBuilder: (context, index) {
                final pelanggaranData = pelanggaranMap.values.toList()[index] as Map<String, dynamic>;
                final namaPelanggaran = pelanggaranData['namaPelanggaran'] as String;
                final timestamp = pelanggaranData['waktu'] as Timestamp;
                final waktu = DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());

                return ListTile(
                  title: Text(namaPelanggaran),
                  subtitle: Text(waktu),
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
