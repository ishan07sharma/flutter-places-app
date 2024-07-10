import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getdb() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'places.db'), version: 1,
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY , title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)');
  });
  return db;
}

class ListProviderNotifier extends StateNotifier<List<Place>> {
  ListProviderNotifier() : super(const []);
  Future<void> loadplaces() async{
    final db=await getdb();
    final places = await db.query('user_places');
    final allplaces= places.map((row)=>
        Place(id: row['id'] as String, title: row['title'] as String, image:File(row['image'] as String) , location: Placelocation(latitude: row['lat'] as double, longitude: row['lon'] as double, address: row['address'] as String))
    ).toList();
    state=allplaces;
  }

  void addItem(String item, File image, Placelocation location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedimage = await image.copy('${appDir.path}/$filename');

    Place newPlace = Place(title: item, image: copiedimage, location: location);
    final db = await getdb();
    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lon': newPlace.location.longitude,
      'address': newPlace.location.address
    });
    state = [...state, newPlace];
  }
}

final listProvider = StateNotifierProvider<ListProviderNotifier, List<Place>>(
    (ref) => ListProviderNotifier());
