import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/providers/placeslist.dart';
import 'package:native_features/screens/addplace.dart';
import 'package:native_features/widgets/places_list.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {

  late Future<void> _loadplace;
  @override
  void initState() {
    super.initState();
    _loadplace = ref.read(listProvider.notifier).loadplaces();
  }
  void _addplace() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddplaceScreen()));
  }

  List<Place> placeslist = [];

  @override
  Widget build(BuildContext context) {
    
  
    List<Place> temp = ref.watch(listProvider);
    setState(() {
      placeslist = temp;
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Your Places'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addplace,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _loadplace,
            builder: (context, snapshot) => 
              snapshot.connectionState==ConnectionState.waiting?
              const Center(
                child: CircularProgressIndicator(),
              ):
              PlacesList(
                places: placeslist,
              )
            
          ),
        ));
  }
}
