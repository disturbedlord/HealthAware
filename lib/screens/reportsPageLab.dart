import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_ssn/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class reportPageLab extends StatefulWidget {
  @override
  _reportPageLabState createState() => _reportPageLabState();
}

class _reportPageLabState extends State<reportPageLab> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  String accessCode = "1234";

  final _text = TextEditingController();
  bool _validate = false;
  String labId = "";

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
        appBar: AppBar(
          title: Text("Fill the report"),
          centerTitle: true,
        ),
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
                    // controller.setMapStyle(_mapStyle);
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
            Text("Long Press the Location to register the Area."),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  padding: EdgeInsets.only(top: 10.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Lab Report ID",
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Lab ID",
                          hasFloatingPlaceholder: true,
                          errorText:
                              _validate ? "This ID doesn't exist" : null),
                      onChanged: (value) {
                        labId = value;
                        _validate = false;
                        setState(() {});
                        print(labId);
                      },
                      controller: _text,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Doctor ID",
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Disease Name",
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Disease Detected (Y/N)",
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          print(labId + "  " + accessCode);
                          if (labId == accessCode) {
                            _validate = false;
                            labId = "";
                            print("ok");
                          } else {
                            _validate = true;
                            labId = "";
                            _text.clear();
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                              child: Text("Submit",
                                  style: TextStyle(fontSize: 20.0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
