// import 'home_page.dart';
import 'package:flutter/material.dart';

import 'pages/page_choose_device.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SynerMycha',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageChooseDevice(),
    );
  }
}
