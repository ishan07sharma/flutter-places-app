import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:native_features/models/place.dart';

class Maps extends StatefulWidget {
  const Maps(
      {super.key,
      this.location = const Placelocation(
        latitude: 37.422,
        longitude: -122.084,
        address: '',
      ),
      this.isSelecting = true});
  final Placelocation location;
  final bool isSelecting;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.isSelecting?'Pick your location':'Your location'),
        actions: [
          if (widget.isSelecting)
          IconButton(onPressed: (){
            Navigator.of(context).pop(_pickedlocation);
          }, icon: const Icon(Icons.save))
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              LatLng(widget.location.latitude, widget.location.longitude),
          initialZoom: 16,
          onTap: widget.isSelecting==false?null: (tapPosition, point) {
            setState(() {
              _pickedlocation = point;
            });
            //print(point.latitude);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          (_pickedlocation==null && widget.isSelecting)?const MarkerLayer(markers: []):
          MarkerLayer(
            markers: [
               Marker(
                  point:_pickedlocation?? LatLng(
                      widget.location.latitude, widget.location.longitude),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ))
            ],
          ),
          // RichAttributionWidget(
          //   attributions: [
          //     TextSourceAttribution(
          //       'OpenStreetMap contributors',
          //       onTap: () =>
          //           launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  launchUrl(Uri parse) {}
}
