import 'package:flutter/material.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/screens/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});
  final Place place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    String apikey=dotenv.env['TOMTOM_API_KEY']!;
    return 'https://api.tomtom.com/map/1/staticimage?key=$apikey&format=png&label=hybrid&language=en-GB&zoom=15&center=$lng,$lat&width=600&height=300';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(place.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => Maps(isSelecting: false,location:Placelocation(latitude: place.location.latitude, longitude: place.location.longitude, address: place.location.address) ,)));
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(locationImage),
                        )),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(place.location.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                    )
                  ],
                )),
          ],
        ));
  }
}
