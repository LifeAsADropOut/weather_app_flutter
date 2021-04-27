import 'package:flutter/material.dart';
import 'package:weather_app/utils.dart';

const String API_KEY = "878286a9eb6402f9a8d720f905722563";

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationText = "GET LOCATION";

  final LocationTracker _locationTracker = LocationTracker();

  Future<void> _getLocation() async {
    GeoLocationData _data = await _locationTracker.getLocation();

    if (_data.status == LocationStatus.denied) {
      setState(() {
        locationText = "FAILED TO GET LOCATION PERMISSION!";
      });
    } else
      setState(() {
        locationText = _data.locationData.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RawMaterialButton(
          onPressed: () {
            _getLocation();
          },
          fillColor: Colors.blue,
          padding: EdgeInsets.all(10.0),
          child: Text(
            locationText,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
