import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';
import 'package:tw_logger/src/helper/tw_datebase_helper.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';

class TWLabelHelper {
  /// handle label cache
  @transaction
  static Future<bool> handleLabelCache(String label, String type) async {
    if (!TWLoggerConfigure().open) {
      return false;
    }
    final res = await findItemByTypeAndTitle(type, label);
    if (res == null) {
      insertItem(
        type: type,
        label: label,
      );
      return true;
    } else {
      debugPrint('Label existed');
      return false;
    }
  }

  @transaction
  static Future<bool> handleRemoveLabelCache(String label, String type) async {
    final res = await findItemByTypeAndTitle(type, label);
    if (res != null) {
      deleteItemById(res.id!);
      return true;
    } else {
      debugPrint('Label not existed');
      return false;
    }
  }

  /// insert label
  static Future<void> insertItem({
    required String type,
    required String label,
  }) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.label.insertItem(
        TWLabel.optional(
          type: type,
          title: label,
        ),
      );
    } catch (e) {
      debugPrint('TwLabelHelper insertItem error: $e');
    }
  }

  /// find all label by type
  static Future<List<TWLabel>> findAllItemsByType(String type) async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.label.findAllItemsByType(type);
    } catch (e) {
      debugPrint('TwLabelHelper findAllItemsByType error: $e');
      return [];
    }
  }

  /// find label by type and title
  static Future<TWLabel?> findItemByTypeAndTitle(
    String type,
    String title,
  ) async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.label.findItemByTypeAndTitle(type, title);
    } catch (e) {
      debugPrint('TwLabelHelper findItemByTypeAndTitle error: $e');
      return null;
    }
  }

  /// find by id
  static Future<TWLabel?> findItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.label.findItemById(id);
    } catch (e) {
      debugPrint('TwLabelHelper findItemById error: $e');
      return null;
    }
  }

  /// delete all
  static Future<void> deleteAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      db.label.deleteAllItems();
    } catch (e) {
      debugPrint('TwLabelHelper deleteAllItems error: $e');
    }
  }

  /// delete crash log by id
  static Future<void> deleteItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.label.deleteItemById(id);
    } catch (e) {
      debugPrint('TwLabelHelper deleteItemById error: $e');
    }
  }
}
