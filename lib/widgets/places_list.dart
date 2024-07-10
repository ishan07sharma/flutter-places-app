import 'package:flutter/material.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/screens/place_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;
  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return  Center(
          child: Text("No places addded yet",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)));
    }
    return ListView.builder(
     
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding:const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
            leading: CircleAvatar(backgroundImage:FileImage(places[index].image) ,radius: 26,),
            onTap: () =>Navigator.push(context,MaterialPageRoute(builder:(context)=>PlaceDetail(place: places[index]) )) ,
            title: Text(places[index].title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text(places[index].location.address,
            style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface)
            ),
          );
        });
  }
}
