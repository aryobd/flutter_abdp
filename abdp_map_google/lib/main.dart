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
  // final List<Circle> _lstCircle = [];
  final List<LatLng> _lstLatLng = [];
  final List<Polyline> _lstPolyline = [];
  Uint8List? markerIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    // target: LatLng(37.42796133580664, -122.085749655962),
    target: LatLng(-6.175268555139486, 106.82713374020734), // MONAS - ABDP
    // zoom: 14.4746,
    zoom: 12, // ABDP
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    // target: LatLng(37.43296265331129, -122.08832357078792),
    target: LatLng(-6.360980580587045, 106.74806032068038), // WATES - ABDP
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

  // Circle _circle = Circle(
  //   circleId: CircleId("Cicle 1"),
  //   radius: 250,
  //   strokeColor: Colors.red,
  //   strokeWidth: 5,
  //   fillColor: Colors.redAccent.withOpacity(0.1),
  //   center: LatLng(-6.360980580587045, 106.74806032068038),
  // );

  // static final Polyline _polyline = Polyline(
  //   polylineId: PolylineId("Polyline 1"),
  //   points: const [
  //     LatLng(-6.360980580587045, 106.74806032068038), // WATES - ABDP
  //     LatLng(-6.360980580587045, 106.77), // ABDP
  //   ],
  //   color: Colors.red,
  //   width: 5,
  // );

  Polygon _polygon = Polygon(
    polygonId: const PolygonId("Polygon 1"),
    points: const [
      LatLng(0, 0),
    ],
    strokeColor: Colors.blue,
    strokeWidth: 2,
    fillColor: Colors.red.withOpacity(0.2),
  );

  // Future<Uint8List> getMarkerIcon(String image, int size) async {
  //   ByteData bytData = await rootBundle.load(image);
  //   ui.Codec codec = await ui.instantiateImageCodec(
  //       bytData.buffer.asUint8List(),
  //       targetHeight: size);
  //   ui.FrameInfo info = await codec.getNextFrame();
  //   return (await info.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  @override
  Widget build(BuildContext context) {
    // Polyline _polylines = Polyline(
    //   polylineId: PolylineId("Polyline 1"),
    //   points: _points,
    //   color: Colors.red,
    //   width: 5,
    // );

    return Scaffold(
      // Call GoogleMap() for rendering Google Map screen // ABDP
      body: GoogleMap(
        // markers: {_marker},
        markers: Set<Marker>.from(_lstMarker), // ABDP
        // circles: {_circle},
        // circles: Set<Circle>.from(_lstCircle), // ABDP
        // polylines: {_polyline},
        // polylines: {_polylines},
        polylines: Set<Polyline>.from(_lstPolyline),
        polygons: {_polygon},
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

          _lstLatLng.add(LatLng(position.latitude, position.longitude));

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

          // _lstCircle.add(Circle(
          //   circleId: CircleId("Circle ${_lstCircle.length}"),
          //   radius: 250,
          //   strokeColor: Colors.red,
          //   strokeWidth: 5,
          //   fillColor: Colors.redAccent.withOpacity(0.2),
          //   center: LatLng(position.latitude, position.longitude),
          // ));

          _lstPolyline.add(Polyline(
            polylineId: PolylineId("Polyline ${_lstPolyline.length}"),
            points: _lstLatLng,
            color: Colors.red,
            width: 5,
          ));

          setState(() {});
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        // onPressed: _goToTheLake,
        // label: const Text('To the lake!'),
        onPressed: closePolyline,
        label: const Text('Close Line'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> closePolyline() async {
    _lstLatLng.add(LatLng(_lstLatLng[0].latitude, _lstLatLng[0].longitude));

    _lstPolyline.add(Polyline(
      // polylineId: PolylineId("Polyline ${_lstPolyline.length}"),
      polylineId: PolylineId("Polyline ${_lstPolyline.length + 1}"),
      points: _lstLatLng,
      color: Colors.red,
      width: 5,
    ));

    _polygon = Polygon(
      polygonId: const PolygonId("Polygon 1"),
      points: _lstLatLng,
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.red.withOpacity(0.2),
    );

    setState(() {});
  }
}
