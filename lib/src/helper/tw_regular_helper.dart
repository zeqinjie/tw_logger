import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tw_logger/src/helper/tw_datebase_helper.dart';
import 'package:tw_logger/src/db/table/tw_regular.dart';
import 'package:tw_logger/src/helper/tw_stack_trace_helper.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';

class TWRegularHelper {
  /// handle log cache
  static handleLogCache(OutputEvent event) {
    if (!TWLoggerConfigure().open) {
      return;
    }
    final message = event.origin.message;
    final level = event.origin.level.toString();
    final time = event.origin.time;
    final stacktrace = TWStackTraceHelper.getStackTraceInfo(
      stacktrace: event.origin.stackTrace,
    );
    TWRegularHelper.insertItem(
      message: message,
      time: time,
      level: level,
      stacktrace: stacktrace,
    );
  }

  /// insert regular log
  static Future<void> insertItem({
    required String message,
    required DateTime time,
    required String level,
    required String stacktrace,
  }) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.regular.insertItem(
        TWRegular.optional(
          message: message,
          time: time,
          level: level,
          stacktrace: stacktrace,
        ),
      );
    } catch (e) {
      debugPrint('TWRegularHelper insertItemCache error: $e');
    }
  }

  /// get all regular log
  static Future<List<TWRegular>> findAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.regular.findAllItems();
    } catch (e) {
      debugPrint('TWRegularHelper getAllRegular error: $e');
      return [];
    }
  }

  /// delete all regular log
  static Future<void> deleteAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      db.regular.deleteAllItems();
    } catch (e) {
      debugPrint('TWRegularHelper deleteAllRegular error: $e');
    }
  }

  /// delete regular log by id
  static Future<void> deleteItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.regular.deleteItemById(id);
    } catch (e) {
      debugPrint('TWRegularHelper deleteRegularById error: $e');
    }
  }
}
