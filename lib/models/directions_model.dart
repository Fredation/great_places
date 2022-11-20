import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds? bounds;
  final List<PointLatLng>? polylinePoints;
  final String? totalDistance;
  final String? totalDuration;

  Directions(
      {required this.bounds,
      required this.polylinePoints,
      required this.totalDistance,
      required this.totalDuration});

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isNotEmpty) {
      final data = Map<String, dynamic>.from(map['routes'][0]);

      //Bounds
      final northEast = data['bounds']['northeast'];
      final southWest = data['bounds']['southwest'];
      final bounds = LatLngBounds(
        southwest: LatLng(southWest['lat'], southWest['lng']),
        northeast: LatLng(northEast['lat'], northEast['lng']),
      );

      //Distance and Duration
      String distance = '';
      String duration = '';

      if ((data['legs'] as List).isNotEmpty) {
        final leg = data['legs'][0];

        distance = leg['distance']['text'];
        duration = leg['duration']['text'];
      }

      return Directions(
          bounds: bounds,
          polylinePoints: PolylinePoints()
              .decodePolyline(data['overview_polyline']['points']),
          totalDistance: distance,
          totalDuration: duration);
    }

    return Directions(
      bounds: null,
      polylinePoints: null,
      totalDistance: null,
      totalDuration: null,
    );
  }
}
