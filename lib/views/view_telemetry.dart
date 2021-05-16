import 'dart:ui';

import 'package:flutter/material.dart';

class ViewTelemetry extends StatefulWidget {
  final Widget body;
  final Widget appBar;
  final bool loader;
  final bool hasDrawer;
  final bool blurredLoader;
  final bool showSafeAreaTop;
  final bool showSafeAreaBottom;

  ViewTelemetry(
      {@required this.body,
      this.appBar,
      this.loader = false,
      this.showSafeAreaTop = true,
      this.showSafeAreaBottom = false,
      this.blurredLoader = false,
      this.hasDrawer = false});

  @override
  _ViewTelemetryState createState() => _ViewTelemetryState();
}

class _ViewTelemetryState extends State<ViewTelemetry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: _buildStack(),
    ));
  }

  Widget _buildLabel(text) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black45,
        ),
        padding: EdgeInsets.all(4),
        child: Text(text,
            style: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              fontFeatures: [
                FontFeature.tabularFigures(),
                FontFeature.stylisticSet(6)
              ],
              color: Colors.white,
            )),
      );

  Widget _buildStack() => Stack(
        // alignment: const Alignment(0.6, 0.6),
        children: [
          Image.asset('assets/synermycha.png',
              scale: 1.0, width: 300, height: 400),
          _buildLabel("2340.98"),
        ],
      );
}
