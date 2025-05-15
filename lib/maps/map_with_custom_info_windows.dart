import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithCustomInfoWindows extends StatefulWidget {
  const MapWithCustomInfoWindows({super.key});

  @override
  State<MapWithCustomInfoWindows> createState() =>
      _MapWithCustomInfoWindowsState();
}

class _MapWithCustomInfoWindowsState extends State<MapWithCustomInfoWindows> {
  LatLng myCurrentLocation = const LatLng(-7.7487118, 113.7023999);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final CollectionReference placeCollection = FirebaseFirestore.instance
      .collection('alumniVerified');

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
    _listenToMarkers();
  }

  Future<void> _loadCustomIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(12, 12)),
      'assets/images/home.png',
    );
  }

  void _listenToMarkers() {
    placeCollection.snapshots().listen((QuerySnapshot streamSnapshot) {
      if (streamSnapshot.docs.isNotEmpty) {
        final List myMarkers = streamSnapshot.docs;
        List<Marker> loadedMarkers = [];

        for (final marker in myMarkers) {
          final data = marker.data() as Map<String, dynamic>;

          if (data['location'] is GeoPoint) {
            final GeoPoint location = data['location'];
            final LatLng latLng = LatLng(location.latitude, location.longitude);

            loadedMarkers.add(
              Marker(
                markerId: MarkerId(data['address'] ?? marker.id),
                position: latLng,
                icon: customIcon,
                onTap: () {
                  _customInfoWindowController.hideInfoWindow!();
                  _customInfoWindowController.addInfoWindow!(
                    _buildInfoWindow(data),
                    latLng,
                  );
                },
              ),
            );
          }
        }

        setState(() {
          markers = loadedMarkers;
        });
      }
    });
  }

  Widget _buildInfoWindow(Map data) {
    return Container(
      height: 120,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    (data['image'] != null && data['image'] is String)
                        ? NetworkImage(data['image'])
                        : const AssetImage('assets/images/home.png')
                            as ImageProvider,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data['name'] ?? 'Alumni',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data['address'] ?? ''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        showModalBottomSheet(
          clipBehavior: Clip.none,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              color: Colors.white,
              height: size.height * 0.77,
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.77,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: myCurrentLocation,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) {
                        googleMapController = controller;
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      onTap: (argument) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      markers: markers.toSet(),
                      // Tambahkan properti berikut untuk memastikan kamera dapat digeser
                      scrollGesturesEnabled: true, // Mengaktifkan geser kamera
                      zoomGesturesEnabled: true, // Mengaktifkan zoom
                      rotateGesturesEnabled: true, // Mengaktifkan rotasi kamera
                      tiltGesturesEnabled:
                          true, // Mengaktifkan kemiringan kamera
                    ),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: size.height * 0.34,
                    width: size.width * 0.85,
                    offset: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 170,
                        vertical: 5,
                      ),
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      label: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: const [
            SizedBox(width: 5),
            Text(
              "Map",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.map_outlined, color: Colors.white),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
