// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapWithCustomInfoWindows1 extends StatefulWidget {
//   final GeoPoint userLocation;

//   const MapWithCustomInfoWindows1({Key? key, required this.userLocation})
//     : super(key: key);

//   @override
//   _MapWithCustomInfoWindows1State createState() =>
//       _MapWithCustomInfoWindows1State();
// }

// class _MapWithCustomInfoWindows1State extends State<MapWithCustomInfoWindows1> {
//   late GoogleMapController _mapController;
//   late LatLng _initialPosition;
//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _initialPosition = LatLng(
//       widget.userLocation.latitude,
//       widget.userLocation.longitude,
//     );
//     _fetchAlumniLocations();
//   }

//   Future<void> _fetchAlumniLocations() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('alumniVerified').get();

//     Set<Marker> markers =
//         snapshot.docs
//             .map((doc) {
//               final data = doc.data();
//               final GeoPoint? geo = data['location'];
//               if (geo == null) return null;

//               final String name = data['name'] ?? 'Alumni';
//               final String address = data['address'] ?? '-';
//               final String year = data['graduationYear'] ?? '';
//               final String job = data['job'] ?? '';

//               return Marker(
//                 markerId: MarkerId(doc.id),
//                 position: LatLng(geo.latitude, geo.longitude),
//                 infoWindow: InfoWindow(
//                   title: name,
//                   snippet: '$job\n$address\nLulus: $year',
//                 ),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueAzure,
//                 ),
//               );
//             })
//             .whereType<Marker>()
//             .toSet();

//     setState(() {
//       _markers = markers;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Peta Alumni")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _initialPosition,
//           zoom: 14,
//         ),
//         onMapCreated: (controller) => _mapController = controller,
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }
// }
