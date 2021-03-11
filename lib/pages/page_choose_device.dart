import 'package:flutter/material.dart';
import 'package:synermycha_app/smart_scale.dart';
import 'package:synermycha_app/bluetooth_repository.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'page_device.dart';

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

    widget.bluetoothRepostiory
        .scanSpecific()
        .listen((List<ScanResult> results) {
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
  Widget build(BuildContext context) =>
      Scaffold(body: _buildListViewOfDevices());

  ListView _buildListViewOfDevices() {
    List<Card> listTiles = [];
    for (BluetoothDevice device in widget.devicesList) {
      listTiles.add(Card(
        child: ListTile(
          title: Text(device.name == '' ? '(unknown device)' : device.name),
          subtitle: Text(device.id.toString()),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageDevice())
            );
            widget.bluetoothRepostiory.connectToBLEDevice(device);
          },
        ),
      ));
    }

    return ListView(
      children: <Widget>[
        ...listTiles,
      ],
    );
  }
}


class ListTileDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
