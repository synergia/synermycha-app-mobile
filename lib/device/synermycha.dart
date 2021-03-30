import 'package:flutter/foundation.dart' show required, debugPrint;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:synermycha_app/utils/ble_consts.dart';
import 'device_info.dart';

class SynerMycha {
  BluetoothDevice device;
  List<BluetoothService> services = [];

  DeviceInfo deviceInfo = DeviceInfo();

  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;

  var _weight = <int>[];

  double get weight {
    var list = _weight.toString().padLeft(4, "0").split("");
    list.insert(list.length - 2, ".");
    String weight = list.join();
    return double.parse(weight);
  }

  SynerMycha._create({@required BluetoothDevice device}) {
    this.device = device;
  }

  static SynerMycha create({@required BluetoothDevice device}) {
    var object = SynerMycha._create(device: device);

    // await object._setup();

    return object;
  }

  // Future<void> connect({Duration timeout, bool autoConnect = true,}) async {
  //   return await this.device.connect(timeout: timeout);
  // }

  Future<void> setup() async {
    services = await device?.discoverServices();

    deviceInfo.service = await getService(services, BleUUIDs.SERV_DEVICE_INFO);
    deviceInfo.refresh();


    // List<BluetoothCharacteristic> bluetoothCharacteristics =
    //     _getBluetoothCharacteristics(services: services);

    // _setupWriteCharacteristic(
    //     bluetoothCharacteristics: bluetoothCharacteristics);

    // _setupNotifyCharacteristic(
    //     bluetoothCharacteristics: bluetoothCharacteristics);
  }

  Future<BluetoothService> getService(List<BluetoothService> services, String serviceUUID) async {
    try {
      final service = services.firstWhere((element) => element.uuid.toString().contains(serviceUUID), orElse: null);
      return service;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _setupWriteCharacteristic({@required List<BluetoothCharacteristic> bluetoothCharacteristics}) {
    _writeCharacteristic = bluetoothCharacteristics
        .firstWhere((characteristic) => characteristic.uuid == Guid("0000ffb1-0000-1000-8000-00805f9b34fb"));
  }

  void _setupNotifyCharacteristic({@required List<BluetoothCharacteristic> bluetoothCharacteristics}) {
    _notifyCharacteristic = bluetoothCharacteristics
        .firstWhere((characteristic) => characteristic.uuid == Guid("0000ffb2-0000-1000-8000-00805f9b34fb"));
  }

  Future<void> startDataStream() async {
    // here I set notifyValue to true to receive data from scale
    // I also handle the payload

    // await _notifyCharacteristic.setNotifyValue(true);
    // _handlePayload();
    // await _synchronizeTime();
    // await _setMeasurementUnit();

    print("Start data stream");
  }

  void _handlePayload() => _notifyCharacteristic.value.listen((payload) async {
        if (payload.isEmpty) return;

        debugPrint(payload.toString());
        _updateWeightData(payload);
        _updateBodyFatData(payload);
      });

  void _updateWeightData(List<int> payload) {
    if (payload[2] >= 252) return;
    if (payload[0] == 172 && payload[1] == 2) _weight = [payload[3], payload[4]];
  }

  void _updateBodyFatData(List<int> payload) {}

  // below you will find a couple of methods I wrote and tried to run based on the API

  Future<void> _handleUserInfoRequest(List<int> payload) async {
    if (payload[payload.length - 2] == 206) {
      await _syncUserID();
      await _syncUserInformation();
    }
  }

  Future<void> _syncUserID() async =>
      await _writeCharacteristic.write([0xAC, 0x02, 0xFB, 0x01, 0x1B, 0xAC, 0xCC, 0x71], withoutResponse: true);

  Future<void> _syncUserInformation() async {
    await _writeCharacteristic.write([0xAC, 0x02, 0xFA, 0x01, 0x00, 0x00, 0xCC, 0x39], withoutResponse: true);
  }

  Future<void> _setMeasurementUnit() async {
    // try to set measurement unit as Kilograms
    await _writeCharacteristic.write(
      [0xAC, 0x02, 0xFE, 0x06, 0x00, 0x00, 0xCC, 0x30],
      withoutResponse: true,
    );
    debugPrint("measurement sent");
  }

  Future<void> _synchronizeTime() async {
    final now = DateTime.now();
    final checksum = (253 + (now.year - 2000) + now.month + now.day + 204) % 255;

    // try to sync date to current day, 18:00:00

    await _writeCharacteristic.write([0xAC, 0x02, 253, 21, 2, 24, 204, 8], withoutResponse: true);
    await _writeCharacteristic.write([0xAC, 0x02, 0xFC, 0x12, 0x00, 0x00, 0xCC, 0x26], withoutResponse: true);

    debugPrint("timesync sent");
  }

  // this is something I have put together by studying the prints from the demo sdk you provided
  // It is the only thing the scale reacts to
  // if I run this after connecting I receive some payload form the scale, but the API does not provide information
  // regarding what exactly is happening

  Future<void> _initCMD() async {
    await _writeCharacteristic.write([172, 0x02, 0xF7, 0x00, 0x00, 0x00, 0xCC, 0xC3], withoutResponse: true);
    await _writeCharacteristic.write(
        [173, 0x01, 0xA2, 0x0F, 0xE6, 0x7E, 0x7D, 0x08, 0x4E, 0x68, 0xBE, 0x7F, 0x0E, 0x45, 0xDF, 0x61, 0xDC, 0x79],
        withoutResponse: true);
    await _writeCharacteristic.write([0xAE, 0x03, 0x02, 0x04, 0x01, 0x07], withoutResponse: true);
    await _writeCharacteristic.write([0xAC, 0x02, 0xFE, 0x1E, 0x00, 0x00, 0xCC, 0xE8], withoutResponse: true);
  }

  Future<void> dispose() async {
    await _notifyCharacteristic.setNotifyValue(false);
    await device.disconnect();
  }
}
