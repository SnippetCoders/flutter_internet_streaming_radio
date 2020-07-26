import 'dart:async';
import 'package:internet_radio/models/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      String _path = p.join(databasesPath, 'RadioApp.db');
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE radios (id INTEGER PRIMARY KEY NOT NULL, radioName STRING, radioURL STRING, radioDesc STRING, radioWebsite STRING, radioPic String)');
    await db.execute(
        'CREATE TABLE radios_bookmarks (id INTEGER PRIMARY KEY NOT NULL, isFavourite INTEGER)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, DBBaseModel model) async =>
      await _db.insert(table, model.toMap());

  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async =>
      _db.rawQuery(sql);

  static Future<int> rawInsert(String sql) async => await _db.rawInsert(sql);
}
