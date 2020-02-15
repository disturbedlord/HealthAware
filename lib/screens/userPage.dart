import 'package:flutter/material.dart';
import 'package:maps_ssn/screens/MapPage.dart';
import 'package:maps_ssn/screens/labMapPage.dart';
import 'package:nice_button/NiceButton.dart';

class userPage extends StatefulWidget {
  @override
  _userPageState createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HealthWare"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NiceButton(
                width: 255,
                padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                elevation: 8.0,
                radius: 10.0,
                text: "End User",
                background: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapSample()),
                  );
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              NiceButton(
                width: 450,
                elevation: 8.0,
                padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                radius: 10.0,
                text: "Labs",
                background: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => labMapPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
