import 'package:flutter/material.dart';
import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
import 'package:synermycha_app/bluetooth_manager.dart';
import 'package:synermycha_app/device/synermycha.dart';

class RouteDevice extends StatelessWidget {
  final BluetoothManager bluetoothManager;
  // final BluetoothDevice synermycha;

  RouteDevice({Key key, @required this.bluetoothManager}) : super(key: key);
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

  Widget _buildView(context, SynerMycha synermycha) {
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
              print(synermycha.deviceInfo.softwareRevision);
              _fetchDeviceInfo(context, synermycha);
            },
            child: Text(
              synermycha.device.name,
              style: TextStyle(color: Colors.black),
            ),
          )),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          // Respond to item press.
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            label: 'Music',
            icon: Icon(Icons.music_note),
          ),
          BottomNavigationBarItem(
            label: 'Places',
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            label: 'News',
            icon: Icon(Icons.library_books),
          ),
        ],
      ),
    );
  }

  void _fetchDeviceInfo(context, SynerMycha synermycha) {
    showDialog(
        context: context,
        builder: (ctxt) => new SimpleDialog(
              title: Text("SynerMycha information"),
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Manufacturer: " + synermycha.deviceInfo.manufacturerName),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Software rev.: " + synermycha.deviceInfo.softwareRevision),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Firmware rev.: " + synermycha.deviceInfo.firmwareRevision),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Text("Hardware rev.: " + synermycha.deviceInfo.hardwareRevision),
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
