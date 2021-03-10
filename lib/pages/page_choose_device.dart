import 'package:flutter/material.dart';
import 'package:synermycha_app/smart_scale.dart';
import 'package:synermycha_app/bluetooth_repository.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PageChooseDevice extends StatefulWidget {
  PageChooseDevice({Key key}) : super(key: key);

  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  BluetoothRepostiory bluetoothRepostiory = BluetoothRepostiory();


  @override
  _PageChooseDeviceState createState() => _PageChooseDeviceState();
}

class _PageChooseDeviceState extends State<PageChooseDevice> {
  SmartScale _scale;
  Future _future;
  String _status = "Disconnected";


  @override
  void initState() {
    super.initState();

  widget.bluetoothRepostiory.ble.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        print(result.device.name);
        _addDeviceTolist(result.device);
      }
    });
    widget.bluetoothRepostiory.ble.startScan();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: _buildListViewOfDevices()

    );

  ListView _buildListViewOfDevices() {
    List<ListTile> listTiles = [];
    for (BluetoothDevice device in widget.devicesList) {
      listTiles.add(
        ListTile(
          title: Text(device.name == '' ? '(unknown device)' : device.name),
          subtitle: Text(device.id.toString()),
        ),
      );
    }

    return ListView(
      children: <Widget>[
        ...listTiles,
      ],
    );
  }
}