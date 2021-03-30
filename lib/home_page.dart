// import 'bluetooth_manager.dart';
// // import 'smart_scale.dart';
// import 'package:flutter/material.dart';

// // ! PLEASE MAKE SURE BLUETOOTH AND LOCATION ARE ON, I HAVE NOT PROVIDED CHECK IMPLEMENTATION FOR THOSE

// class HomePage extends StatefulWidget {
//   const HomePage({Key key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // SmartScale _scale;
//   // BluetoothRepostiory _bluetoothRepostiory;
//   Future _future;
//   String _status = "Disconnected";

//   @override
//   void initState() {
//     super.initState();
//     _bluetoothRepostiory = BluetoothRepostiory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Scale Demo"),
//           elevation: 0,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text("Scale Status:"),
//                   Text("$_status"),
//                 ],
//               ),
//               RaisedButton(
//                 onPressed: () async {
//                   try {
//                     setState(() {
//                       _status = "Connecting";
//                     });
//                     // var scale = await _bluetoothRepostiory.connectScale();
//                     setState(() {
//                       // _scale = scale;
//                       _future = _scale.startDataStream();
//                       _status = "Connected";
//                     });
//                   } on Exception catch (e) {
//                     setState(() {
//                       _status = e.toString() + ". Try Again!";
//                     });
//                   }
//                 },
//               ),
//               FutureBuilder(
//                 future: _future,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.none)
//                     return Text("Data stream is not started");
//                   else if (snapshot.connectionState == ConnectionState.done)
//                     return Text(
//                         "Started data stream, you can step on scale to receive payload");
//                   else
//                     return CircularProgressIndicator();
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }
