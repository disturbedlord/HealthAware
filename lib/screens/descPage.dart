import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_ssn/utils/constants.dart';

class descPage extends StatefulWidget {
  @override
  _descPageState createState() => _descPageState();
}

class _descPageState extends State<descPage> {
  String desc = Description[0];
  String sym = Symptoms[0];
  String prev = Prevention[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Malaria"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Desc : ",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.bold))),
            Text("$desc",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 20.0,
                ))),
            SizedBox(
              height: 20.0,
            ),
            Text("Symptoms : ",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.bold))),
            Text("$sym",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 20.0,
                ))),
            SizedBox(
              height: 20.0,
            ),
            Text("Prevention : ",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.bold))),
            Text("$prev",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 20.0,
                ))),
          ],
        ),
      ),
    );
  }
}
