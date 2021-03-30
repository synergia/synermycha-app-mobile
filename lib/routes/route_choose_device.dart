import 'package:flutter/material.dart';
import 'package:synermycha_app/device/synermycha.dart';
import 'package:synermycha_app/bluetooth_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'route_device.dart';

class RouteChooseDevice extends StatefulWidget {
  RouteChooseDevice({Key key}) : super(key: key);

  final List<BluetoothDevice> devicesList = [];
  BluetoothManager bluetoothManager = BluetoothManager();

  @override
  _RouteChooseDeviceState createState() => _RouteChooseDeviceState();
}

class _RouteChooseDeviceState extends State<RouteChooseDevice> {
  // SmartScale _scale;
  Future _future;
  String _status = "Disconnected";

  @override
  void initState() {
    super.initState();

    widget.bluetoothManager.scanSpecific().listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        print(result.device.name);
        _addDeviceTolist(result.device);
      }
    });
    widget.bluetoothManager.ble.startScan();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: _buildListViewOfDevices());

  ListView _buildListViewOfDevices() {
    List<Card> listTiles = [];
    for (BluetoothDevice device in widget.devicesList) {
      listTiles.add(Card(
        child: ListTile(
          title: Text(device.name == '' ? '(unknown device)' : device.name),
          subtitle: Text(device.id.toString()),
          onTap: () async {
            widget.bluetoothManager.createSynerMycha(device);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RouteDevice(bluetoothManager: widget.bluetoothManager)));
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
