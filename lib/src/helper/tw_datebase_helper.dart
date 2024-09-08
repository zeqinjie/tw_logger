import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/tw_database.dart';

class TWDataBaseHelper {
  TWDatabase? _database;

  static final TWDataBaseHelper _instance = TWDataBaseHelper._internal();
  factory TWDataBaseHelper() => _instance;
  TWDataBaseHelper._internal();

  static Future<TWDatabase> database() async {
    if (TWDataBaseHelper()._database != null) {
      return TWDataBaseHelper()._database!;
    }
    final callback = Callback(
      onCreate: (database, version) {
        debugPrint('database onCreate: $version');
      },
      onOpen: (database) {
        debugPrint('database onOpen');
      },
      onUpgrade: (database, startVersion, endVersion) {
        debugPrint('database onUpgrade: $startVersion -> $endVersion');
      },
    );
    try {
      final database = await $FloorTWDatabase
          .databaseBuilder('tw_logger_database.db')
          .addCallback(callback)
          .build();
      TWDataBaseHelper()._database = database;
      return database;
    } catch (e) {
      debugPrint('TWDataBaseHelper  error: $e');
      rethrow;
    }
  }
}
