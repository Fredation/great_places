import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/geocoding.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:great_places/helpers/location_helper.dart';
// import 'package:great_places/widgets/location_input.dart';

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
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
//     final body = PlacesAutocompleteResult(
//       onTap: (p) {
//         displayPrediction(p, searchScaffoldKey.currentState);
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

// class AddressSearch extends SearchDelegate<Suggestion>{
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     // TODO: implement buildActions
//     throw UnimplementedError();
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     // TODO: implement buildLeading
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }

// }
