import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:collection';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'bluetoothManager.dart';
import 'connectionIndicator.dart';
import "config.dart";
import "bluetoothConfig.dart";
import 'drawer.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ListenableProvider<BluetoothManager>(create: (_) => BluetoothManager()),
    ],
    child: MaterialApp(
      title: 'Navigation Basics',
      home: HomeScreen(),
    ),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text("status: "), ConnectionIndicator()]),
      ),
      body: Center(child: const Text('Press the button below!')),
      floatingActionButton: Consumer<BluetoothManager>(
        builder: (context, btman, child) {
          return FloatingActionButton(
              child: Icon(Icons.send),
              onPressed: () => btman.writeData("YOLO"),
              backgroundColor: Colors.red,
            );
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: WidgetDrawer(),
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
