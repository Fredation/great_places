import 'package:flutter/material.dart';
import 'package:great_places/screens/google_map_screen.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  //const PlaceDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments.toString();
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedPlace.location!.address!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => GoogleMapScreen(
                    initialLocation: selectedPlace.location!,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: const Text('View On Map'),
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
