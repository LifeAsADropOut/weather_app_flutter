import 'package:flutter/material.dart';
import 'package:weather_app/utils.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationText = "";

  final LocationTracker _locationTracker = LocationTracker();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

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
          ),
        ),
      ),
    );
  }
}
