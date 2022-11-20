import 'dart:developer';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/places.dart';

import '../screens/google_map_screen.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);
  final Function onSelectPlace;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  final Mode _mode = Mode.overlay;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _getCurrentLocationData() async {
    final locationData = await loc.Location().getLocation();
    final staticMapUrl = LocationHelpers.generateLocationPreviewImage(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
    widget.onSelectPlace(
      locationData.latitude,
      locationData.longitude,
    );
  }

  Future<void> _getFromSearch(double lat, double lng) async {
    final staticMapUrl = LocationHelpers.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
    widget.onSelectPlace(
      lat,
      lng,
    );
  }

  Future<void> _selectOnMap() async {
    final LatLng? _selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => GoogleMapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (_selectedLocation != null) {
      final dynamicMapUrl = LocationHelpers.generateLocationPreviewImage(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      );
      setState(() {
        _previewImageUrl = dynamicMapUrl;
      });
      widget.onSelectPlace(
          _selectedLocation.latitude, _selectedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentLocationData,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select From Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
        //_buildDropdownMenu(),
        ElevatedButton(
          onPressed: _handlePressButton,
          child: const Text("Search places"),
        ),
      ],
    );
  }

  // Widget _buildDropdownMenu() {
  //   return DropdownButton(
  //     value: _mode,
  //     items: const <DropdownMenuItem<Mode>>[
  //       DropdownMenuItem<Mode>(
  //         child: Text("Overlay"),
  //         value: Mode.overlay,
  //       ),
  //       DropdownMenuItem<Mode>(
  //         child: Text("Fullscreen"),
  //         value: Mode.fullscreen,
  //       ),
  //     ],
  //     onChanged: (Mode? m) {
  //       setState(() {
  //         _mode = m!;
  //       });
  //     },
  //   );
  // }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!.showSnackBar(
      const SnackBar(content: Text("error")),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GOOGLE_API_KEY,
      types: [],
      strictbounds: false,
      onError: onError,
      mode: _mode,
      language: "en",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "ng")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  displayPrediction(Prediction? p, ScaffoldState? scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: GOOGLE_API_KEY,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      log(lat.toString());
      log(lng.toString());
      _getFromSearch(lat!, lng!);

      //widget.onSelectPlace(lat, lng);

      scaffold?.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
}

// class CustomSearchScaffold extends PlacesAutocompleteWidget {
//   CustomSearchScaffold()
//       : super(
//           apiKey: GOOGLE_API_KEY,
//           sessionToken: Uuid().generateV4(),
//           language: "en",
//           components: [Component(Component.country, "uk")],
//         );

//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }

// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   //final LocationInput locationInput = LocationInput();
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
//     final body = PlacesAutocompleteResult(
//       onTap: (p) {
//        displayPrediction(p, searchScaffoldKey.currentState);
//       },
//       logo: Row(
//         children: [FlutterLogo()],
//         mainAxisAlignment: MainAxisAlignment.center,
//       ),
//     );
//     return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
//   }

//   @override
//   void onResponseError(PlacesAutocompleteResponse response) {
//     super.onResponseError(response);
//     searchScaffoldKey.currentState.showSnackBar(
//       SnackBar(content: Text(response.errorMessage)),
//     );
//   }

//   @override
//   void onResponse(PlacesAutocompleteResponse response) {
//     super.onResponse(response);
//     if (response != null && response.predictions.isNotEmpty) {
//       searchScaffoldKey.currentState.showSnackBar(
//         SnackBar(content: Text("Got answer")),
//       );
//     }
//   }
// }

// class Uuid {
//   final Random _random = Random();

//   String generateV4() {
//     // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
//     final int special = 8 + _random.nextInt(4);

//     return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
//         '${_bitsDigits(16, 4)}-'
//         '4${_bitsDigits(12, 3)}-'
//         '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
//         '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
//   }

//   String _bitsDigits(int bitCount, int digitCount) =>
//       _printDigits(_generateBits(bitCount), digitCount);

//   int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

//   String _printDigits(int value, int count) =>
//       value.toRadixString(16).padLeft(count, '0');
// }
