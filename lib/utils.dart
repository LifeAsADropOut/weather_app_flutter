// ignore: import_of_legacy_library_into_null_safe
import 'package:location/location.dart';

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

    if (_serviceEnabled || _permissionGranted == PermissionStatus.denied)
      return GeoLocationData(locationData: null, status: LocationStatus.denied);

    return GeoLocationData(
      locationData: await _location.getLocation(),
      status: LocationStatus.denied,
    );
  }
}

class GeoLocationData {
  final LocationData? locationData;
  final LocationStatus status;
  GeoLocationData({required this.locationData, required this.status});
}

enum LocationStatus { denied, granted }
