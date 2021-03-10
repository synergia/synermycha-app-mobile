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

  Stream<List<ScanResult>> scanResults () {
    return ble.scanResults;
  }

  Future<BluetoothDevice> _handleScaleConnected() async {
    var connectedDevices = await ble.connectedDevices;
    if (connectedDevices.length > 0) {
      var device = connectedDevices
          .firstWhere((element) => element.name.toLowerCase().contains("fake"));
      if (device != null) {
        print("already connected");
        return device;
      }
    }

    return null;
  }

  Future<void> getBluetoothPermission() async {
    var isAvailable = await ble.isAvailable;
    if (!isAvailable) throw Exception("Bluetooth is not available");
  }
}
