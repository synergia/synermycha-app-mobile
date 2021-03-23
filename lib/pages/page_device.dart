import 'package:flutter/material.dart';
import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
import 'package:synermycha_app/bluetooth_manager.dart';
import 'package:synermycha_app/device/synermycha.dart';

class PageDevice extends StatelessWidget {
  final BluetoothManager bluetoothManager;
  // final BluetoothDevice synermycha;

  PageDevice({Key key, @required this.bluetoothManager}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<SynerMycha>(
        future: bluetoothManager.setupSynermycha(),
        builder: (context, AsyncSnapshot<SynerMycha> snapshot) {
          if (snapshot.hasData) {
            return _buildView(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return _loadingView();
        });
  }

  Widget _buildView(context, synermycha) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close),
            onPressed: () {
              synermycha.device.disconnect();
              Navigator.pop(context);
            },
          ),
          title: InkWell(
            onTap: () {
              _fetchDeviceInfo(context, synermycha);
            },
            child: Text(
              synermycha.device.name,
              style: TextStyle(color: Colors.black),
            ),
          )),
      body: Center(),
    );
  }

  Future<void> _fetchDeviceInfo(context, SynerMycha synermycha) async {
    final firmwareRev = await synermycha.deviceInfo.firmwareRevision;
    final softwareRev = await synermycha.deviceInfo.softwareRevision;
    final manuName = await synermycha.deviceInfo.manufacturerName;
    final hardwareRev = await synermycha.deviceInfo.hardwareRevision;

    showDialog(
        context: context,
        builder: (ctxt) => new SimpleDialog(
              title: Text("Device information"),
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Manufacturer: " + manuName),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Software rev.: " + softwareRev),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Firmware rev.: " + firmwareRev),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Hardware rev.: " + hardwareRev),
                      ),
                    ])
              ],
              // content: Text(synermycha.deviceInfo.softwareRevision),
            ));
  }

  Widget _loadingView() {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                Colors.purple.shade900,
              ))),
          // Container(height: 10),
          // Text("Łącze się...", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
        ],
      )),
    );
  }
}
