import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Map<String, Marker> _markers = {};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  CircleId? selectedCircle;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List<dynamic> _mapThemes = [
    {
      'name': 'Standard',
      'style': null, // Default style
    },
    {
      'name': 'Dark',
      'style': '[YOUR_DARK_MAP_STYLE]', // Replace with your dark map style JSON
    },
    {
      'name': 'Retro',
      'style':
          '[YOUR_RETRO_MAP_STYLE]', // Replace with your retro map style JSON
    },
  ];

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Page"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            zoomControlsEnabled: true,
            markers: _markers.values.toSet(),
            circles: circles.values.toSet(),
            onTap: (LatLng latLng) {
              _customInfoWindowController.hideInfoWindow!();
              Marker marker = Marker(
                draggable: true,
                markerId: MarkerId(latLng.toString()),
                position: latLng,
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1606089397043-89c1758008e0?ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDEyMHx6b01WalRMU2tlUXx8ZW58MHx8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
                              fit: BoxFit.cover,
                              height: 130,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Grand Teton National Park",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Grand Teton National Park on the east side of the Teton Range is renowned for great hiking trails with stunning views of the Teton Range.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            onPressed: () {},
                            elevation: 0,
                            height: 40,
                            minWidth: double.infinity,
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "See details",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    latLng,
                  );
                },
              );

              setState(() {
                _markers[latLng.toString()] = marker;
              });
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 60.0,
          ),
          Positioned(
            bottom: 40,
            right: 15,
            child: Container(
              width: 35,
              height: 105,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      _controller?.animateCamera(CameraUpdate.zoomIn());
                    },
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, size: 25),
                  ),
                  const Divider(height: 5),
                  MaterialButton(
                    onPressed: () {
                      _controller?.animateCamera(CameraUpdate.zoomOut());
                    },
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.remove, size: 25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
