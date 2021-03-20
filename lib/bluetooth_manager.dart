import 'device/synermycha.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  final ble = FlutterBlue.instance;
  SynerMycha synermycha;

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

  Future<SynerMycha> connectToBLEDevice(BluetoothDevice device) async {
    await ble.stopScan();
    // BluetoothDevice synermycha_device = await _checkIfAlreadyConnected(device);

    try {
      await device.connect(timeout: Duration(seconds: 10));
      synermycha = SynerMycha.create(device: device);
    } catch (e) {
      if (e.code != 'already_connected') {
        throw e;
      }
    }
    return synermycha;
  }

  Future<SynerMycha> setupSynermycha() async {
    if (await isAlreadyConnected(synermycha.device)) {
      return synermycha;
    }

    try {
      await synermycha.device.connect(timeout: Duration(seconds: 10), autoConnect: false);
      await synermycha.setup();
    } catch (e) {
      // if (e) {
      //   throw e;
      // }
      throw e;
    }
    return synermycha;
  }

  SynerMycha createSynerMycha(BluetoothDevice device) {
    this.synermycha = SynerMycha.create(device: device);
    return synermycha;
  }

  Stream<List<ScanResult>> scanAll() {
    return ble.scanResults;
  }

  Stream<List<ScanResult>> scanSpecific() {
    return ble.scanResults.map((s) => s.where((d) => isSynerMycha(d)).map((i) => i).toList());
  }

  bool isSynerMycha(ScanResult scanResult) {
    print(scanResult.device.name);
    return scanResult.device.name.contains("Syner");
  }

  Future<bool> isAlreadyConnected(BluetoothDevice device) async {
    var connectedDevices = await ble.connectedDevices;
    if (connectedDevices.length > 0) {
      var synermycha = connectedDevices.firstWhere((element) => connectedDevices.contains(device), orElse: () => null);
      if (synermycha != null) {
        print(synermycha.name + " is already connected.");
        return true;
      }
    }
    print(device.name + "is not connected.");
    return false;
  }

  Future<void> getBluetoothPermission() async {
    var isAvailable = await ble.isAvailable;
    if (!isAvailable) throw Exception("Bluetooth is not available");
  }
}
