import 'package:flutter/material.dart';
import 'package:synermycha_app/bluetooth_manager.dart';
import 'package:synermycha_app/device/synermycha.dart';
import 'package:synermycha_app/views/view_telemetry.dart';

class RouteDevice extends StatefulWidget {
  const RouteDevice({Key key, @required this.bluetoothManager}) : super(key: key);

  final BluetoothManager bluetoothManager;

  @override
  _RouteDeviceState createState() => _RouteDeviceState();
}

class _RouteDeviceState extends State<RouteDevice> {
  int _selectedIndex = 0;
  final _pageViewController = PageController();

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ViewTelemetry(),
    Text(
      'Map',
      style: optionStyle,
    ),
    Text(
      'Lights',
      style: optionStyle,
    ),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    // _showDialog();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.bluetoothManager.synermycha == null) {
      return new FutureBuilder<SynerMycha>(
          future: widget.bluetoothManager.setupSynermycha(), //TODO: Move this to choose device
          builder: (context, AsyncSnapshot<SynerMycha> snapshot) {
            if (snapshot.hasData) {
              return _buildView(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return _loadingView();
          });
    // } else {
    //   return _buildView(context, widget.bluetoothManager.synermycha);
    // }
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
              widget.bluetoothManager.closeSynermycha();
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
      body: Center(
          child: PageView(
        controller: _pageViewController,
        children: _widgetOptions,
        onPageChanged: _onItemTapped,
      )),
      // Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // )
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (index) {
          _pageViewController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.bounceOut);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Telemetry',
          ),
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(Icons.map_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Lights',
            icon: Icon(Icons.lightbulb_outline),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _selectedIndex,
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
