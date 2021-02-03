import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show utf8;

enum Status { uninitialized, connected, disconnected, scanning }

class BluetoothManager with ChangeNotifier {
  BluetoothDevice _ebike;
  Status status;
  SharedPreferences prefs;

  BluetoothService serv_uart;
  BluetoothCharacteristic char_uart_tx;
  BluetoothCharacteristic char_uart_rx;

  final String SERV_UUID_UART = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  final String CHAR_UUID_UART_TX = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  final String CHAR_UUID_UART_RX = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  BluetoothManager() {
    print("bluetoothmanager created");
    status = Status.uninitialized;
    _autoConnect();
  }

  void setupListeners() async {
    // update the connection state if it changes on bluetooth
    await for (var state in _ebike.state) {
      if (state == BluetoothDeviceState.connected) {
        status = Status.connected;
      } else {
        status = Status.disconnected;
      }
      notifyListeners();
    }
  }

  void setEbike(BluetoothDevice device) {
    _ebike = device;
    //status = Status.connected;
    setupListeners();
    _saveDevice(device);
    notifyListeners();
  }

  void writeData(String data) {
    log("Sending: " + data);
    if (char_uart_rx == null) return;

    List<int> bytes = utf8.encode(data);
    char_uart_rx.write(bytes);
  }

  void _autoConnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceAddress = prefs.getString('autoConnect');
    if (deviceAddress != null) {
      print("starting auto connect search for " + deviceAddress);
      FlutterBlue blue = FlutterBlue.instance;
      blue.startScan();
      print("scan started");
      blue.scanResults.listen((results) async {
        // do something with scan results
        for (ScanResult r in results) {
          print("found " + r.device.id.toString() + ": " + r.device.name);
          if (r.device.id.toString() == deviceAddress) {
            print("connecting to saved device " +
                deviceAddress +
                " with rssi: ${r.rssi}");
            await r.device.connect(autoConnect: true);
            blue.stopScan();
            setEbike(r.device);
          }
        }
      });
    } else {
      print("device addres is null");
    }
  }

  void _saveDevice(BluetoothDevice device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('saving autoconnect device ' + device.id.toString());
    await prefs.setString('autoConnect', device.id.toString());
  }
}
