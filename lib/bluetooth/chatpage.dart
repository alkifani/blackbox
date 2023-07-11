import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bb/bluetooth/ambil_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  String? mulaiValue;
  bool? isSendingLocation;

  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = <_Message>[];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;

  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    ///listenToMulaiValueChanges();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection?.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> mulaiState(String state) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('IDAlat')
        .where('email', isEqualTo: user!.email)
        .get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.update({'mulai': state});
    });
  }

  // void listenToMulaiValueChanges() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     FirebaseFirestore.instance
  //         .collection('IDAlat')
  //         .where('email', isEqualTo: user.email)
  //         .snapshots()
  //         .listen((snapshot) {
  //       try {
  //         if (snapshot.size > 0) {
  //           final document = snapshot.docs.first;
  //           setState(() {
  //             mulaiValue = document['mulai'] as String?;
  //           });
  //
  //           // Start sending location data if mulaiValue is "1"
  //           if (mulaiValue == '1') {
  //             sendLocationDataToFirestore();
  //             setState(() {
  //               isSendingLocation = true;
  //             });
  //           } else {
  //             setState(() {
  //               isSendingLocation = false;
  //             });
  //             stopSendingLocationDataToFirestore();
  //           }
  //         }
  //       } catch (error) {
  //         print('Error listening to mulai value changes: $error');
  //       }
  //     });
  //   }
  // }

  // Future<void> sendLocationDataToFirestore() async {
  //   final geolocator = GeolocatorPlatform.instance;
  //
  //   try {
  //     // Check location permission
  //     LocationPermission permission = await geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permission denied, request permission from user
  //       permission = await geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         // Permission not granted, show a dialog to the user
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text('Location Permission'),
  //             content: const Text('Location permission not granted.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //         return;
  //       }
  //     }
  //
  //     // Get current location
  //     Position? currentPosition = await geolocator.getCurrentPosition();
  //
  //     // Send location data to Firestore
  //     if (currentPosition != null) {
  //       final user = FirebaseAuth.instance.currentUser;
  //       if (user != null) {
  //         final latitude = currentPosition.latitude;
  //         final longitude = currentPosition.longitude;
  //         final speedMS = currentPosition.speed; // Speed in meters per second
  //         final speedKMH = (speedMS * 3.6).roundToDouble(); // Convert speed to km/h
  //         final timestamp = DateTime.now();
  //         final geoPoint = GeoPoint(latitude, longitude);
  //         print(geoPoint);
  //         final querySnapshot = await FirebaseFirestore.instance
  //             .collection('IDAlat')
  //             .where('email', isEqualTo: user!.email)
  //             .get();
  //
  //         querySnapshot.docs.forEach((doc) {
  //           doc.reference.update({'gpsperdetik': geoPoint});
  //           doc.reference.update({'speed': speedKMH});
  //           doc.reference.update({'timestamp': timestamp});
  //         });
  //
  //         print('Location data sent successfully.');
  //       }
  //     } else {
  //       print('Unable to get current location.');
  //     }
  //   } catch (error) {
  //     // Error handling
  //     print('Error sending location data: $error');
  //   }
  // }
  //
  //
  // Future<void> stopSendingLocationDataToFirestore() async {
  //   // Set the flag to stop sending location data
  //   setState(() {
  //     isSendingLocation = false;
  //   });
  // }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              _message.text.trim(),
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
              color:
              _message.whom == clientID ? Colors.blueAccent : Colors.grey,
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isConnecting
              ? 'Connecting chat to ${widget.server.name}...'
              : isConnected
              ? 'Live chat with ${widget.server.name}'
              : 'Chat log with ${widget.server.name}',
        ),
        backgroundColor: Color.fromRGBO(0, 28, 48, 0.5),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color here
          size: 30, // Change the size here
        ),
      ),
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (mulaiValue == '') {
            //         // Start functionality
            //         mulaiState("1");
            //         setState(() {
            //           isSendingLocation = true;
            //         });
            //       } else if (mulaiValue == '1') {
            //         // Stop functionality
            //         mulaiState("");
            //         setState(() {
            //           isSendingLocation = false;
            //         });
            //         stopSendingLocationDataToFirestore();
            //       }
            //     },
            //     child: Text(mulaiValue == '' ? 'Mulai GPS' : 'Stop GPS'),
            //   ),
            // ),

            Center(
              child: ElevatedButton(
                  onPressed: isConnected
                      ? () => _sendMessage("Mulai")
                      : null, child: Text("Mulai")
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _sendMessage("Berhenti");
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          AmbilData(),
                    ),);
                  },
                  child: Text("Berhenti")
              ),
            ),
            Center(
              child: TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: isConnecting
                      ? 'Wait until connected...'
                      : isConnected
                      ? 'Hubungkan atau Putuskan Koneksi'
                      : 'Chat got disconnected',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                enabled: isConnected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        connection?.output.add(Uint8List.fromList(utf8.encode(text + '\r\n')));
        await connection?.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
            listScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 333),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        setState(() {});
      }
    }
  }
}