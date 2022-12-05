import 'package:latlong2/latlong.dart';

class GeoLocation {
  final String? name;
  final String? address;
  final LatLng? latlng;
  final double? altitude;
  final DateTime? time;

  GeoLocation({
    required this.name,
    required this.address,
    required this.latlng,
    required this.altitude,
    required this.time,
  });
}

final mapMarkers = [];
List<String> locationData = [];
