// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/tw_crash_dao.dart';
import 'dao/tw_label_dao.dart';
import 'dao/tw_network_dao.dart';
import 'dao/tw_regular_dao.dart';
import 'table/tw_crash.dart';
import 'table/tw_label.dart';
import 'table/tw_network.dart';
import 'table/tw_regular.dart';
part 'tw_database.g.dart';

// flutter packages pub run build_runner build --delete-conflicting-outputs
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

@Database(version: 1, entities: [
  TWRegular,
  TWCrash,
  TWNetwork,
  TWLabel,
])
@TypeConverters([DateTimeConverter])
abstract class TWDatabase extends FloorDatabase {
  TWRegularDao get regular;
  TWCrashDao get crash;
  TWNetworkDao get network;
  TWLabelDao get label;
}
