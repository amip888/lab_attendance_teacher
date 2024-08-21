// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Position currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//   }

//   Future<void> getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         currentLocation = position;
//       });

//       print('Current Location: ${position.latitude}, ${position.longitude}');

//       // Mendapatkan koordinat yang berjarak sekitar 10 meter dari titik GPS
//       double targetDistance = 10.0; // Jarak dalam meter
//       double targetBearing = 45.0; // Arah dalam derajat

//       LocationDistance distance = LocationDistance(distance: targetDistance, bearing: targetBearing);
//       Location newLocation = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         distance.latitude!,
//         distance.longitude!,
//       );

//       print('New Location: ${newLocation.latitude}, ${newLocation.longitude}');
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Geo Location Example'),
//       ),
//       body: Center(
//         child: currentLocation == null
//             ? CircularProgressIndicator()
//             : Text('Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}'),
//       ),
//     );
//   }
// }
