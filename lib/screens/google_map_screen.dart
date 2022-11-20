import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/directions_model.dart';

import '../models/place.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    Key? key,
    this.initialLocation = const PlaceLocation(
      latitude: 8.9641419,
      longitude: 7.4568435,
    ),
    this.isSelecting = true,
  }) : super(key: key);
  final PlaceLocation initialLocation;
  final bool isSelecting;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? _selectedLocation;
  late GoogleMapController _googleMapController;
  Directions? _info;

  final Marker _originMarker = Marker(
    infoWindow: const InfoWindow(title: "Origin"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    markerId: const MarkerId('m2'),
    position: const LatLng(
      9.0794,
      7.4859,
    ),
  );

  void _selectLocation(LatLng? position) async {
    setState(() {
      _selectedLocation = position;
    });

    final directions = await LocationHelpers.getDirection(
        origin: const LatLng(9.0794, 7.4859), destination: position!);
    setState(() {
      _info = directions;
    });
    if (_info != null) {
      _googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(_info!.bounds!, 100));
    }
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _initialCameraPosition = CameraPosition(
      target: LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
      ),
      zoom: 12,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_selectedLocation);
                    },
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onTap: widget.isSelecting ? _selectLocation : null,
            onMapCreated: (controller) => _googleMapController = controller,
            polylines: {
              if (_info != null)
                Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.blue,
                    width: 5,
                    points: _info?.polylinePoints != null
                        ? _info!.polylinePoints!
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList()
                        : [
                            const LatLng(
                              9.0794,
                              7.4859,
                            ),
                            _selectedLocation!
                          ])
            },
            markers: (_selectedLocation == null && widget.isSelecting)
                ? {_originMarker}
                : {
                    _originMarker,
                    Marker(
                      markerId: const MarkerId('m1'),
                      infoWindow: const InfoWindow(title: "Destination"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                      position: _selectedLocation ??
                          LatLng(
                            widget.initialLocation.latitude,
                            widget.initialLocation.longitude,
                          ),
                    ),
                  },
          ),
          if (_info != null)
            Positioned(
              top: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text('${_info!.totalDistance}, ${_info!.totalDuration}'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds!, 100)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
