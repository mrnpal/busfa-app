import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AlumniMapPage extends StatefulWidget {
  const AlumniMapPage({Key? key}) : super(key: key);

  @override
  _AlumniMapPageState createState() => _AlumniMapPageState();
}

class _AlumniMapPageState extends State<AlumniMapPage> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(-7.7496725, 113.6984635); // fallback posisi
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
    _fetchAlumniLocations();
  }

  Future<void> _setInitialLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied)
        return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  Future<void> _fetchAlumniLocations() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('alumniVerified').get();

    Set<Marker> markers =
        snapshot.docs
            .map((doc) {
              final data = doc.data();
              final GeoPoint? geo = data['location'];
              if (geo == null) return null;

              return Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(geo.latitude, geo.longitude),
                infoWindow: InfoWindow(
                  title: data['name'] ?? 'Alumni',
                  snippet: data['phone'] ?? '',
                ),
              );
            })
            .whereType<Marker>()
            .toSet();

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peta Alumni")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
        onMapCreated: (controller) => _mapController = controller,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
