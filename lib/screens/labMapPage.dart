import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:maps_ssn/screens/reports.dart';
import 'package:maps_ssn/screens/reportsPageLab.dart';
import 'package:maps_ssn/screens/visualize.dart';
import 'package:maps_ssn/utils/constants.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:permission_handler/permission_handler.dart';

class labMapPage extends StatefulWidget {
  @override
  State<labMapPage> createState() => labMapPageState();
}

class labMapPageState extends State<labMapPage> {
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

  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId(1.toString()),
      center: LatLng(13.0822222222222, 80.2755555555556),
      radius: 4000,
      fillColor: Color(0xAF42A5F5),
      strokeColor: Color(0xAF42A5F5),
    )
  ]);
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

  Future<Uint8List> getBytesFromCanvas(int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.grey;

    final Radius radius = Radius.circular(50.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(25.0, 25.0, 50.0, 50.0),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: '.',
      style: TextStyle(fontSize: 350.0, color: Colors.red),
    );
    painter.layout();
    painter.paint(canvas, Offset(6, -258.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                    final Uint8List markerIcon =
                        await getBytesFromCanvas(200, 100);
                    // final Marker marker =
                    //     Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
                    // final MarkerId o = MarkerId(1.toString());
                    // final Marker p = Marker(
                    //     markerId: o,
                    //     position: LatLng(12.9972222222222, 80.2569444444444),
                    //     icon: BitmapDescriptor.fromBytes(markerIcon));

                    for (int i = 0; i < latitude.length; i++) {
                      int index = i + 1;
                      final MarkerId id = MarkerId(i.toString());
                      final Marker marker = Marker(
                        markerId: id,
                        position: LatLng(latitude[i], longitude[i]),
                        infoWindow: InfoWindow(
                          title: area[i],
                          snippet: "$index reports have been submitted",
                        ),
                      );

                      setState(() {
                        markers[id] = marker;
                      });
                    }
                  },
                  buildingsEnabled: true,
                  // myLocationEnabled: true,
                  compassEnabled: false,
                  circles: circles,
                  onLongPress: (LatLng latLng) async {
                    // creating a new MARKER
                    printVal();
                    var markerIdVal = markers.length + 1;
                    String mar = markerIdVal.toString();
                    final MarkerId markerId = MarkerId(mar);
                    final Uint8List markerIcon =
                        await getBytesFromCanvas(200, 100);

                    final Marker marker = Marker(
                        markerId: markerId,
                        position: latLng,
                        icon: BitmapDescriptor.fromBytes(markerIcon));

                    setState(() {
                      markers[markerId] = marker;
                      print(markers);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: "location",
                          child: Icon(Icons.location_searching),
                          onPressed: () async {
                            PermissionStatus permission =
                                await PermissionHandler().checkPermissionStatus(
                                    PermissionGroup.location);

                            _goCurrentLocation();
                            requestLocation();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FloatingActionButton(
                          heroTag: "menu",
                          child: Icon(Icons.menu),
                          onPressed: () {
                            _settingModalBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 5.0),
                            child: new TextField(
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration(
                                hintText: 'Search for a location',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 520.0),
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     shrinkWrap: true,
                //     children: <Widget>[
                //       Container(
                //         width: 180.0,
                //         // height: 10.0,
                //         child: Card(
                //           color: Colors.white,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: <Widget>[
                //                   Text("Report",
                //                       style: GoogleFonts.poppins(
                //                           textStyle:
                //                               TextStyle(fontSize: 18.0))),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       Container(
                //         width: 180.0,
                //         // height: 10.0,
                //         child: Card(
                //           color: Colors.white,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: <Widget>[
                //                   Text("Visualize",
                //                       style: GoogleFonts.poppins(
                //                           textStyle:
                //                               TextStyle(fontSize: 18.0))),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

// TODO
// void _showPointData(context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext bc) {
//       return Container(
//         child: ,
//       );
//     },
//   );
// }

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Wrap(
              children: <Widget>[
                Center(
                  child: Text("Take an action",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 20.0))),
                ),
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => reportPageLab()),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/document.png",
                        scale: 15,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Report",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.orange,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => visualizePage()),
                    // );
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/data-visualization.png",
                        scale: 15,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Visualize",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
