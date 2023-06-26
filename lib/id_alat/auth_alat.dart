import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bb/menu_home/home_page.dart';

class IdAlat extends StatefulWidget {
  static const routeName = "/IdAlat";
  final String email;

  const IdAlat({required this.email});

  @override
  State<IdAlat> createState() => _IdAlatState();
}

class _IdAlatState extends State<IdAlat> {
  late TextEditingController _idAlatController;

  @override
  void initState() {
    super.initState();
    _idAlatController = TextEditingController();
  }

  @override
  void dispose() {
    _idAlatController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    final idAlat = _idAlatController.text;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('IDAlat')
          /// .where('email', isEqualTo: widget.email)
          .where('id', isEqualTo: idAlat)
          .where('kondisi', isEqualTo: "")
          .get();

      if (querySnapshot.size > 0) {
        // ID Alat sesuai dengan yang terdaftar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sukses'),
            content: const Text('ID Alat sesuai!'),
            actions: [
              TextButton(
                onPressed: () {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.update({'kondisi': '1'});
                    doc.reference.update({'email': widget.email});
                  });
                  Navigator.pop(context);
                  Navigator.pushNamed(context, HomePage.routeName);
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
            content: const Text('ID Alat tidak sesuai!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(108, 108, 108, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome ${widget.email} To CO-SENSE APP",
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
              "Silahkan Masukkan ID Alat Black Box Anda \nYang Telah Terdata Pada Sistem!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                controller: _idAlatController,
                decoration: const InputDecoration(hintText: 'ID Alat Black Box'),
                textAlign : TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: _authenticate,
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
