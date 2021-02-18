import 'package:flutter/material.dart';

import "config.dart";
import "bluetoothConfig.dart";

class WidgetDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'SynerMycha',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text('eBike Configuration'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EBikeConfigurationMenu(title: "eBike Configuration")),
              );
            },
          ),
          ListTile(
            title: Text('App Configuration'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppConfigurationMenu()),
              );
            },
          ),
          ListTile(
            title: Text('Bluetooth config'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindDevicesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppConfigurationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppConfigurationMenu"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
