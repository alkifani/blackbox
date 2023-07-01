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
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Color.fromRGBO(23, 107, 135, 1),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: const Text('General')),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                _toggleBluetooth(value);
              },
            ),
            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(_bluetoothState.toString()),
              trailing: ElevatedButton(
                child: const Text('Settings'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text('Local adapter address'),
              subtitle: Text(_address),
            ),
            ListTile(
              title: const Text('Local adapter name'),
              subtitle: Text(_name),
              onLongPress: null,
            ),
            Divider(),
            ListTile(title: const Text('Devices discovery and connection')),
            ListTile(
              title: ElevatedButton(
                child: const Text('Connect to paired device to chat'),
                onPressed: () async {
                  _startDeviceSelection();
                },
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