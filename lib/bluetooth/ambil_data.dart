import 'dart:async';
import 'package:bb/bluetooth/berhasil_upload.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmbilData extends StatefulWidget {
  static String routeName = "/ambil_data";

  @override
  State<AmbilData> createState() => _AmbilDataState();
}

class _AmbilDataState extends State<AmbilData> {
  bool isLoadingRead = true;
  bool isLoadingUpload = false;

  Future<List<List<dynamic>>> _loadCSV() async {
    String csvData = await rootBundle.loadString("assets/csv/Trip1.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
    return csvTable;
  }

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        isLoadingRead = false;
      });
    });
  }

  Widget LoadingHalaman() {
    return Center(
      child: SizedBox(
        height: 80,
        width: 80,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget LoadingUpload() {
    return Center(
      child: SizedBox(
        height: 35,
        width: 35,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

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
        child: isLoadingRead ? LoadingHalaman() : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical:25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 141,
                      height: 148,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff3d9ba5),
                      ),
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xff909090),
                                  border: Border.all(
                                    color: Color(0xff2d4854),
                                    width: 15,
                                  )
                              ),
                            ),
                            Text(
                              "10 KM\nJarak",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 36.1),
                    Container(
                      width: 141,
                      height: 148,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff3d9ba5),
                      ),
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xff909090),
                                  border: Border.all(
                                    color: Color(0xfff60000),
                                    width: 15,
                                  )
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "4",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "PELANGGARAN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 325,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color.fromRGBO(172, 227, 224, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: FutureBuilder<List<List<dynamic>>>(
                    future: _loadCSV(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<List<dynamic>> data = snapshot.data!;
                        data.removeAt(0);
                        return Column(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(
                            //     "Teks Sebelum Perulangan",
                            //     style:
                            //     TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 16,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                    child: Card(
                                      color: Color.fromRGBO(245, 102, 102, 1),
                                      elevation: 2,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Text((index + 1).toString()),
                                        ),
                                        title: Text(
                                          data[index][2].toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ///Text("Start Datetime: ${data[index][0].toString()}"),
                                            Text("Datetime Pelanggaran: ${data[index][1].toString()}", style: TextStyle(color: Colors.white),),
                                            ///Text("Mieleage: ${data[index][3].toString()}"),
                                            ///Text("Travel hours: ${data[index][4].toString()}"),
                                            ///Text("Arrived Datetime: ${data[index][5].toString()}"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 25,),

              isLoadingUpload ? LoadingUpload() : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(218, 255, 251, 1),
                        hintText: 'Masukkan nama driver',
                        enabled: true,
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  SizedBox(height: 25,),

                  SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 2.25,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoadingUpload = true;
                        });
                        Future.delayed(Duration(seconds: 5)).then((_) {
                          setState(() {
                            isLoadingUpload = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => BerhasilUpload()),
                                (Route<dynamic> route) => false,
                          );
                        });
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
                      child: const Text('UPLOAD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
