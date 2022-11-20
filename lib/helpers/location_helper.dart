import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/directions_model.dart';
import 'package:http/http.dart' as http;

//const GOOGLE_API_KEY = 'AIzaSyDe5rgOhCTUNwiA6HdiNxNyjay6V3AYK0U';
const GOOGLE_API_KEY = 'AIzaSyDPkHZ4ovrgDR0WgsCs1aMi89RV8ILI9pg';

class LocationHelpers {
  static String? generateLocationPreviewImage(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=12&size=400x400&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String?> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    log(response.body);
    return json
            .decode(response.body)['results'][0]['formatted_address']
            .toString()
            .substring(0, 7)
            .contains("+")
        ? json.decode(response.body)['results'][1]['formatted_address']
        : json.decode(response.body)['results'][0]['formatted_address'];
  }

  static Future<Directions> getDirection(
      {required LatLng origin, required LatLng destination}) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&sensor=false&mode=driving&origin=${origin.latitude},${origin.longitude}&key=$GOOGLE_API_KEY');

    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    if (response.statusCode == 200) {
      return Directions.fromMap(json.decode(response.body));
    } else {
      throw "error";
    }
  }
}
