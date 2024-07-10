import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:native_features/models/place.dart';
import 'package:native_features/screens/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onselectlocation});
  final void Function(Placelocation) onselectlocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _isLoading = false;
  Placelocation? _pickedLocation;
  void setLocation(double lat,double lng)async{
    final url = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$lat,$lng.json?key=hf1FoHoewrEVX6dmaEpBo6DpVQsMV6Ah');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['addresses'][0]['address']['freeformAddress'];
    setState(() {
      _isLoading = false;
      _pickedLocation =
          Placelocation(address: address, latitude: lat, longitude: lng);
      widget.onselectlocation(_pickedLocation!);
    });
  }

  void onSelectmap() async{
  final pickedlatlng=await Navigator.of(context)
  .push<LatLng>(MaterialPageRoute(builder: (ctx) => const Maps()));
  if(pickedlatlng==null){
    return;
  }
  setLocation(pickedlatlng.latitude,pickedlatlng.longitude);

  }
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    String apikey=dotenv.env['TOMTOM_API_KEY']!;
    return 'https://api.tomtom.com/map/1/staticimage?key=$apikey&format=png&label=hybrid&language=en-GB&zoom=15&center=$lng,$lat&width=600&height=300';
  }

  void _getcuurentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    setLocation(lat,lng);
    
    //print(address);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('No location Choosen',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ));
    if (_isLoading) {
      content = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    return (Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.2))),
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getcuurentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed:onSelectmap, 
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    ));
  }
}
