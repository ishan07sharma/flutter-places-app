import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/providers/placeslist.dart';
import 'package:native_features/widgets/image_input.dart';
import 'package:native_features/widgets/location_input.dart';

class AddplaceScreen extends ConsumerStatefulWidget {
  const AddplaceScreen({super.key});

  @override
  ConsumerState<AddplaceScreen> createState() => _AddplaceScreenState();
}

class _AddplaceScreenState extends ConsumerState<AddplaceScreen> {
  final _formkey = GlobalKey<FormState>();
  File? _selectedimage;
  var _savedplace = '';
  Placelocation? slectedLocation;
  void _savetitle() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (_selectedimage == null || slectedLocation==null) {
        return;
      }
      ref.read(listProvider.notifier).addItem(_savedplace, _selectedimage!,slectedLocation!);
      //print(_savedplace);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(children: <Widget>[
                TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Name must be between 1 and 50 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _savedplace = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ImageInput(
                  onpickimage: (File image) {
                    _selectedimage = image;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                LocationInput(
                  onselectlocation: (Placelocation location) {
                    slectedLocation = location;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: _savetitle,
                  label: const Text('Add Place'),
                  icon: const Icon(Icons.add),
                )
              ]),
            ),
          ),
        ));
  }
}
