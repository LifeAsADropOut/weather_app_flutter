import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const String API_KEY = "878286a9eb6402f9a8d720f905722563";

String getURL({required int lat, required int lon}) =>
    "https://api.openweathermap.org/data/2.5/weather?mode=JSON&lat=$lat&lon=$lon&appid=$API_KEY";

class LocationTracker {
  Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Future<GeoLocationData> getLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) _serviceEnabled = await _location.requestService();

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied)
      _permissionGranted = await _location.requestPermission();

    if (!_serviceEnabled ||
        _permissionGranted == PermissionStatus.denied ||
        _permissionGranted == PermissionStatus.deniedForever)
      return GeoLocationData(locationData: null, status: LocationStatus.denied);

    return GeoLocationData(
      locationData: await _location.getLocation(),
      status: LocationStatus.granted,
    );
  }
}

class GeoLocationData {
  final LocationData? locationData;
  final LocationStatus? status;
  GeoLocationData({required this.locationData, required this.status});
}

enum LocationStatus { denied, granted }

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  Future getWeather() async {
    http.Response _res = await http.get(Uri.parse(url));

    if (_res.statusCode == 200) {
      var _data = jsonDecode(_res.body);
      return {'name': _data['name'], 'temp': _data['main']['temp']};
    } else {
      print("something went wrong.......");
    }
  }
}
