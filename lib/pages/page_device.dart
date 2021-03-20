import 'package:flutter/material.dart';
import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
import 'package:synermycha_app/bluetooth_manager.dart';
import 'package:synermycha_app/device/synermycha.dart';

class PageDevice extends StatelessWidget {
  final BluetoothManager bluetoothManager;
  // final BluetoothDevice synermycha;

  PageDevice({Key key, @required this.bluetoothManager}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       iconTheme: IconThemeData(color: Colors.black),
  //       leading: IconButton(
  //         tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
  //         icon: const Icon(Icons.close),
  //         onPressed: () {},
  //       ),
  //       title: Text(
  //         "Łącze się...",
  //         style: TextStyle(color: Colors.black),
  //       ),
  //     ),
  //     body: Center(
  //         child: FutureBuilder<SynerMycha>(
  //       future: bluetoothManager.setupSynermycha(),
  //       builder: (context, AsyncSnapshot<SynerMycha> snapshot) {
  //         if (snapshot.hasData) {
  //           return Text(snapshot.data.device.name);
  //         } else if (snapshot.hasError) {
  //           return Text("${snapshot.error}");
  //         }
  //         // By default, show a loading spinner
  //         return CircularProgressIndicator();
  //       },
  //     )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<SynerMycha>(
        future: bluetoothManager.setupSynermycha(),
        builder: (context, AsyncSnapshot<SynerMycha> snapshot) {
          if (snapshot.hasData) {
            return _buildView(context, snapshot.data.device);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return _loadingView();
        });
  }

  Widget _buildView(context, device) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Icons.close),
          onPressed: () {
            device.disconnect();
            Navigator.pop(context);
          },
        ),
        title: Text(
          device.name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(),
    );
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
