import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bb/bluetooth/communication.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import './SelectBondedDevicePage.dart';
import 'chatpage.dart';


class KonfigurasiBluetooth extends StatefulWidget {
  static const routeName = "/KonfigurasiBluetooth";

  @override
  State<KonfigurasiBluetooth> createState() => _KonfigurasiBluetoothState();
}

class _KonfigurasiBluetoothState extends State<KonfigurasiBluetooth> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();
    _getBluetoothState();
    _getAddress();
    _getName();
    _listenBluetoothState();
  }

  void _getBluetoothState() async {
    BluetoothState state = await FlutterBluetoothSerial.instance.state;
    setState(() {
      _bluetoothState = state;
    });
  }

  void _getAddress() async {
    String? address = await FlutterBluetoothSerial.instance.address;
    setState(() {
      _address = address!;
    });
  }

  void _getName() async {
    String? name = await FlutterBluetoothSerial.instance.name;
    setState(() {
      _name = name!;
    });
  }

  void _listenBluetoothState() {
    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  void _initCommunication() async {
    Communication com = Communication();
    await com.connectBl(_address);
    com.sendMessage("Hello");
    setState(() {});
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koneksi Bluetooth'),
        backgroundColor: Color.fromRGBO(0, 28, 48, 0.5),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color here
          size: 30, // Change the size here
        ),
      ),
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Container(
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Hidupkan Bluetooth', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                _toggleBluetooth(value);
              },
            ),
            ListTile(
              title: const Text('Status Bluetooth', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),),
              subtitle: Text(_bluetoothState.toString(), style: TextStyle(color: Colors.white),),
              trailing: ElevatedButton(
                child: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black54),),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Adjust the corner radius as desired
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(218, 255, 251, 1), // Red color (RGB: 255, 0, 0)
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Nama Perangkat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),),
              subtitle: Text(_name, style: TextStyle(color: Colors.white),),
              onLongPress: null,
            ),
            ListTile(
              title: const Text('Alamat Perangkat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),),
              subtitle: Text(_address, style: TextStyle(color: Colors.white),),
            ),

            SizedBox(
              height: 55,
            ),

            SizedBox(
              height: 61,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 6),
                child: ElevatedButton(
                  onPressed: () async {
                    _startDeviceSelection();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Adjust the corner radius as desired
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(218, 255, 251, 1), // Red color (RGB: 255, 0, 0)
                    ),
                  ),
                  child: const Text('SANDINGKAN BLUETOOTH DENGAN ALAT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black54),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBluetooth(bool value) async {
    if (value) {
      await FlutterBluetoothSerial.instance.requestEnable();
    } else {
      await FlutterBluetoothSerial.instance.requestDisable();
    }
    setState(() {});
  }

  void _startDeviceSelection() async {
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SelectBondedDevicePage(checkAvailability: false);
        },
      ),
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      _startChat(context, selectedDevice);
    } else {
      print('Connect -> no device selected');
    }
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }
}