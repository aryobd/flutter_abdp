import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _lstMarker = [];
  Uint8List? markerIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    // target: LatLng(37.42796133580664, -122.085749655962),
    target: LatLng(-6.175268555139486, 106.82713374020734), // ABDP
    // zoom: 14.4746,
    zoom: 12, // ABDP
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    // target: LatLng(37.43296265331129, -122.08832357078792),
    target: LatLng(-6.360980580587045, 106.74806032068038), // ABDP
    // tilt: 59.440717697143555,
    // zoom: 19.151926040649414,
    tilt: 60, // ABDP
    zoom: 15, // ABDP
  );

  // Marker _marker = Marker(
  //   markerId: MarkerId("Marker 1"),
  //   position: LatLng(-6.175268555139486, 106.82713374020734),
  //   infoWindow: InfoWindow(
  //     title: "MONAS",
  //     snippet: "Monumen Nasional",
  //   ),
  //   draggable: true,
  // );

  Future<Uint8List> getMarkerIcon(String image, int size) async {
    ByteData bytData = await rootBundle.load(image);
    ui.Codec codec = await ui.instantiateImageCodec(
        bytData.buffer.asUint8List(),
        targetHeight: size);
    ui.FrameInfo info = await codec.getNextFrame();

    return (await info.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Call GoogleMap() for rendering Google Map screen // ABDP
      body: GoogleMap(
        // markers: {_marker},
        markers: Set<Marker>.from(_lstMarker), // ABDP
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // onTap: (position) {
        //   setState(() {
        //     _marker = Marker(
        //       markerId: MarkerId("Marker 1"),
        //       position: LatLng(position.latitude, position.longitude),
        //       infoWindow: InfoWindow(
        //         title: "${position.latitude}, ${position.longitude}",
        //         snippet:
        //             "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
        //       ),
        //       draggable: true,
        //     );
        //   });
        // },
        // onTap: (position) {
        //   setState(() {
        //     _lstMarker.add(Marker(
        //       markerId: MarkerId("Marker ${_lstMarker.length}"),
        //       position: LatLng(position.latitude, position.longitude),
        //       infoWindow: InfoWindow(
        //         title: "Marker ${_lstMarker.length}",
        //         snippet: "${position.latitude}, ${position.longitude}",
        //       ),
        //       draggable: true,
        //     ));
        //   });
        // },
        onTap: (position) async {
          // final Uint8List newIcon =
          //     await getMarkerIcon('assets/images/map-marker-outline-24.png', 10);

          _lstMarker.add(Marker(
            // icon: BitmapDescriptor.fromBytes(newIcon),
            markerId: MarkerId("Marker ${_lstMarker.length}"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: "Marker ${_lstMarker.length}",
              // snippet: "${position.latitude}, ${position.longitude}",
            ),
            draggable: true,
          ));
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
