import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmbilData extends StatefulWidget {
  static String routeName = "/ambil_data";

  @override
  State<AmbilData> createState() => _AmbilDataState();
}

class _AmbilDataState extends State<AmbilData> {
  Future<List<List<dynamic>>> _loadCSV() async {
    String csvData = await rootBundle.loadString("assets/csv/Trip1.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
    return csvTable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: _loadCSV(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<List<dynamic>> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(
                        data[index][2].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Datetime: ${data[index][0].toString()}"),
                          Text("Datetime Pelanggaran: ${data[index][1].toString()}"),
                          Text("Mieleage: ${data[index][3].toString()}"),
                          Text("Travel hours: ${data[index][4].toString()}"),
                          Text("Arrived Datetime: ${data[index][5].toString()}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    );
  }
}
