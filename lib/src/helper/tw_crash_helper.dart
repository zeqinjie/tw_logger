import 'package:flutter/material.dart';
import 'package:tw_logger/src/helper/tw_datebase_helper.dart';
import 'package:tw_logger/src/db/table/tw_crash.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';

class TWCrashHelper {
  /// handle crash cache
  static handleCrashCache(FlutterErrorDetails details) {
    if (!TWLoggerConfigure().open) {
      return;
    }
    final error = details.exception.toString();
    final time = DateTime.now();
    final stacktrace = details.stack.toString();
    TWCrashHelper.insertItem(
      error: error,
      time: time,
      stacktrace: stacktrace.trim(),
    );
  }

  /// insert regular log
  static Future<void> insertItem({
    required String error,
    required DateTime time,
    required String stacktrace,
  }) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.crash.insertItem(
        TWCrash.optional(
          time: time,
          stacktrace: stacktrace.trim(),
          error: error.trim(),
        ),
      );
    } catch (e) {
      debugPrint('TWCrashHelper insertItem error: $e');
    }
  }

  /// get all
  static Future<List<TWCrash>> findAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.crash.findAllItems();
    } catch (e) {
      debugPrint('TWCrashHelper findAllItems error: $e');
      return [];
    }
  }

  /// delete all crash log
  static Future<void> deleteAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      db.crash.deleteAllItems();
    } catch (e) {
      debugPrint('TWCrashHelper deleteAllItems error: $e');
    }
  }

  /// delete crash log by id
  static Future<void> deleteItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.crash.deleteItemById(id);
    } catch (e) {
      debugPrint('TWCrashHelper deleteItemById error: $e');
    }
  }
}
