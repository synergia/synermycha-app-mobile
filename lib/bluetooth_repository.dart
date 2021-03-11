import 'smart_scale.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothRepostiory {
  final ble = FlutterBlue.instance;

  // Future<SmartScale> connectScale() async {
  //   BluetoothDevice bleDevice = await _handleScaleConnected();

  //   if (bleDevice == null) {
  //     await for (ScanResult result
  //         in ble.scan(timeout: Duration(seconds: 60))) {
  //       print(result.device.name);

  //       if (result.device.name.toLowerCase().contains("fake")) {
  //         await ble.stopScan();

  //         print("stopped scanning");

  //         bleDevice = result.device;

  //         await bleDevice.connect(timeout: Duration(seconds: 10));
  //         print("connected");

  //         break;
  //       }
  //     }
  //   }

  //   if (bleDevice != null) {
  //     var scale = await SmartScale.create(device: bleDevice);
  //     print("setup complete");

  //     return scale;
  //   }

  //   throw Exception("No Device Found");
  // }

  Future<void> connectToBLEDevice(BluetoothDevice synermycha) async {
    await ble.stopScan();
    await _checkIfAlreadyConnected(synermycha);
    await synermycha.connect(timeout: Duration(seconds: 10));
    print("Connected to SynerMycha.");
  }

  Stream<List<ScanResult>> scanAll() {
    return ble.scanResults;
  }

  Stream<List<ScanResult>> scanSpecific() {
    // var data = ble.scanResults.map((devices) => devices.where((device) => device.name == "SynerMycha")).toList();
    return ble.scanResults
        .map((s) => s.where((d) => isSynerMycha(d)).map((i) => i).toList());
  }

  bool isSynerMycha(ScanResult scanResult) {
    print(scanResult.device.name);
    return scanResult.device.name.contains("Syner");
  }

  Future<BluetoothDevice> _checkIfAlreadyConnected(
      BluetoothDevice synermycha) async {
    var connectedDevices = await ble.connectedDevices;
    if (connectedDevices.length > 0) {
      var device = connectedDevices
          .firstWhere((element) => connectedDevices.contains(synermycha));
      if (device != null) {
        print("SynerMycha is already connected.");
        return device;
      }
    }
    print("SynerMycha is not connected.");
    return null;
  }

  Future<void> getBluetoothPermission() async {
    var isAvailable = await ble.isAvailable;
    if (!isAvailable) throw Exception("Bluetooth is not available");
  }
}
