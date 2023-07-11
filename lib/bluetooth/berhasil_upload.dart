import 'package:bb/menu_autentikasi.dart';
import 'package:flutter/material.dart';

class BerhasilUpload extends StatelessWidget {
  const BerhasilUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      appBar: AppBar(
        title: Center(child: Text("Upload Data")),
        backgroundColor: Color.fromRGBO(11, 67, 91, 1),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 125,),

              SizedBox(height: 25,),

              Text("Data berhasil di-upload!", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),),

              SizedBox(height: 150,),

              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width / 2.25,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MenuAutentikasi()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the corner radius as desired
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(100, 204, 197, 1), // Red color (RGB: 255, 0, 0)
                    ),
                  ),
                  child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
