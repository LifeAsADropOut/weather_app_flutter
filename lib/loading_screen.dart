import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/location_screen.dart';
import 'package:weather_app/utils.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationText = "GET LOCATION";

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
    } else {
      NetworkHelper _helper = NetworkHelper(
        getURL(
            lat: _data.locationData!.latitude!.round(),
            lon: _data.locationData!.longitude!.round()),
      );

      var data = await _helper.getWeather();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationScreen(
            name: data['name'],
            temp: data['temp'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.pink,
          size: 50.0,
        ),
      ),
    );
  }
}
