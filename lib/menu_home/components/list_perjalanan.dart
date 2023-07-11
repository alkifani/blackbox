import 'package:flutter/material.dart';
import '../../size_config.dart';

class isiListPerjalanan {
  String trip;
  String datetime;
  String rate;

  isiListPerjalanan({
    required this.trip,
    required this.datetime,
    required this.rate,
  });
}

var daftarTrip = [
  isiListPerjalanan(
    trip: "1",
    datetime: "07-06-2023 (22.12)",
    rate: "95/100",
  ),
  isiListPerjalanan(
    trip: "2",
    datetime: "08-06-2023 (20.38)",
    rate: "100/100",
  ),
  isiListPerjalanan(
    trip: "3",
    datetime: "09-06-2023 (21.05)",
    rate: "92/100",
  ),
  isiListPerjalanan(
    trip: "4",
    datetime: "10-06-2023 (19.47)",
    rate: "87/100",
  ),
  isiListPerjalanan(
    trip: "5",
    datetime: "11-06-2023 (20.21)",
    rate: "90/100",
  ),
];

class ListPerjalanan extends StatefulWidget {
  const ListPerjalanan({Key? key}) : super(key: key);

  @override
  State<ListPerjalanan> createState() => _ListPerjalananState();
}

class _ListPerjalananState extends State<ListPerjalanan> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(217, 217, 217, 1),
          borderRadius: BorderRadius.circular(25.0),
        ),
        height: 350,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListView.builder(
            itemCount: daftarTrip.length,
            itemBuilder: (context, index) {
              final isiListPerjalanan trip = daftarTrip[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 11, left: 6, right: 6),
                child: Container(
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
                    color: Color.fromRGBO(100, 204, 197, 1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 11, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trip: ${trip.trip}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.clip, ),
                              Row(
                                children: <Widget>[
                                  Text('Datetime: ${trip.datetime}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.clip)
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 16, right: 18, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Rate", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.clip, ),
                              SizedBox(height: 11,),
                              Text(trip.rate, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(217, 253, 0, 1.0)), overflow: TextOverflow.clip),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
