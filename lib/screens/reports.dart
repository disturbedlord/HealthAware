import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:maps_ssn/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class reportsPage extends StatefulWidget {
  @override
  _reportsPageState createState() => _reportsPageState();
}

class _reportsPageState extends State<reportsPage> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.0822222222222, 80.2755555555556),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.0822222222222, 80.2755555555556),
      // tilt: 59.440717697143555,
      zoom: 30);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    requestLocation();
  }

  void requestLocation() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  void printVal() {
    print(latitude);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                    // final Uint8List markerIcon = await getBytesFromCanvas(200, 100);
                    // final Marker marker =
                    //     Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
                    // final MarkerId o = MarkerId(1.toString());
                    // final Marker p = Marker(
                    //     markerId: o,
                    //     position: LatLng(12.9972222222222, 80.2569444444444),
                    //     icon: BitmapDescriptor.fromBytes(markerIcon));
                  },
                  buildingsEnabled: true,
                  // myLocationEnabled: true,
                  compassEnabled: false,
                  onLongPress: (LatLng latLng) async {
                    // creating a new MARKER
                    printVal();
                    var markerIdVal = markers.length + 1;
                    String mar = markerIdVal.toString();
                    final MarkerId markerId = MarkerId(mar);
                    // final Uint8List markerIcon = await getBytesFromCanvas(200, 100);

                    final Marker marker = Marker(
                      markerId: markerId,
                      position: latLng,
                      // icon: BitmapDescriptor.fromBytes(markerIcon),
                    );

                    setState(() {
                      markers[markerId] = marker;
                      print(markers);
                    });
                  },
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Issue",
                hasFloatingPlaceholder: true,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "No. of Days",
                hasFloatingPlaceholder: true,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Municipality",
                hasFloatingPlaceholder: true,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                    child: Text("Submit", style: TextStyle(fontSize: 20.0))),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
