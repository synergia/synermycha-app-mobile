import 'package:synermycha_app/utils/ble_consts.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceInfo {
  BluetoothService service;

  String firmwareRevision = "N/A";
  String modelNumber = "N/A";
  String hardwareRevision = "N/A";
  String manufacturerName = "N/A";
  String serialNumber = "N/A";
  String softwareRevision = "N/A";

  // List<BluetoothCharacteristic> _getBluetoothCharacteristics({@required List<BluetoothService> services}) {
  //   var service = services.firstWhere((element) => element.uuid == Guid("0000ffb0-0000-1000-8000-00805f9b34fb"));
  //   return service.characteristics;
  // }

  void refresh() async {
    firmwareRevision = await _firmwareRevision;
    modelNumber = await _modelNumber;
    hardwareRevision = await _hardwareRevision;
    manufacturerName = await _manufacturerName;
    serialNumber = await _serialNumber;
    softwareRevision = await _softwareRevision;
  }

  BluetoothCharacteristic _getCharacteristic(String charUUID) {
    return service.characteristics.firstWhere((ch) => ch.uuid == Guid(charUUID));
  }

  Future<String> get _firmwareRevision async {
    var char = _getCharacteristic(BleUUIDs.CHAR_FIRMWARE_REVISION);
    return new String.fromCharCodes(await char.read());
  }

  Future<String> get _modelNumber async {
    var char = _getCharacteristic(BleUUIDs.CHAR_MODEL_NUMBER);
    return new String.fromCharCodes(await char.read());
  }

  Future<String> get _hardwareRevision async {
    var char = _getCharacteristic(BleUUIDs.CHAR_HARDWARE_REVISION);
    return new String.fromCharCodes(await char.read());
  }

  Future<String> get _manufacturerName async {
    var char = _getCharacteristic(BleUUIDs.CHAR_MANUFACTURER_NAME);
    return new String.fromCharCodes(await char.read());
  }

  Future<String> get _serialNumber async {
    var char = _getCharacteristic(BleUUIDs.CHAR_SERIAL_NUMBER);
    return new String.fromCharCodes(await char.read());
  }

  Future<String> get _softwareRevision async {
    var char = _getCharacteristic(BleUUIDs.CHAR_SOFTWARE_REVISION);
    return new String.fromCharCodes(await char.read());
  }
}
