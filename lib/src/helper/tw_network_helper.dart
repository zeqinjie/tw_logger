import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/table/tw_network.dart';
import 'package:tw_logger/src/helper/tw_datebase_helper.dart';
import 'package:tw_logger/src/net/tw_network.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';

class TWNetworkHelper {
  /// handle network cache
  static Future<void> handleNetworkCache({
    required int id,
    TWNetworkEvent? event,
  }) async {
    if (!TWLoggerConfigure().open) {
      return;
    }
    // check if event existed db
    var item = await TWNetworkHelper.findItemById(id);
    if (item != null) {
      // update existed event
      item
        ..requestTime = event?.time ?? DateTime.now()
        ..requestUri = event?.request?.uri
        ..requestData = getBodyData(event?.request?.data)
        ..requestHeaders = event?.request?.headers.toString()
        ..requestMethod = event?.request?.method
        ..responseData = getBodyData(event?.response?.data)
        ..responseStatusCode = event?.response?.statusCode
        ..responseStatusMessage = event?.response?.statusMessage
        ..responseTime = event?.response?.time ?? DateTime.now()
        ..responseHeaders = event?.response?.headers.toString()
        ..error = event?.error?.toString();
      await TWNetworkHelper.updateItem(item);
    } else {
      // insert new event
      await TWNetworkHelper.insertItem(
        id: id,
        requestTime: event?.time,
        requestUri: event?.request?.uri,
        requestData: event?.request?.data.toString(),
        requestHeaders: event?.request?.headers.toString(),
        requestMethod: event?.request?.method,
        responseData: event?.response?.data.toString(),
        responseStatusCode: event?.response?.statusCode,
        responseStatusMessage: event?.response?.statusMessage,
        responseHeaders: event?.response?.toString(),
        responseTime: event?.response?.time,
        error: event?.error?.toString(),
      );
    }
  }

  static String getBodyData(dynamic body) {
    String text;
    if (body == null) {
      text = '';
    } else if (body is String) {
      text = body;
    } else if (body is List || body is Map) {
      text = const JsonEncoder.withIndent('  ').convert(body);
    } else {
      text = body.toString();
    }
    return text;
  }

  /// insert network log
  static Future<void> insertItem({
    int? id,
    DateTime? requestTime,
    String? requestUri,
    String? requestMethod,
    String? requestHeaders,
    String? requestData,
    String? responseHeaders,
    DateTime? responseTime,
    int? responseStatusCode,
    String? responseStatusMessage,
    String? responseData,
    String? error,
  }) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.network.insertItem(
        TWNetwork.optional(
          id: id,
          requestTime: requestTime,
          requestUri: requestUri,
          requestMethod: requestMethod,
          requestHeaders: requestHeaders,
          requestData: requestData,
          responseHeaders: responseHeaders,
          responseStatusCode: responseStatusCode,
          responseStatusMessage: responseStatusMessage,
          responseData: responseData,
          responseTime: responseTime,
          error: error,
        ),
      );
    } catch (e) {
      debugPrint('TWNetworkHelper insertBookCache error: $e');
    }
  }

  /// update
  static Future<void> updateItem(TWNetwork item) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.network.updateItem(item);
    } catch (e) {
      debugPrint('TWNetworkHelper updateItem error: $e');
    }
  }

  /// get all
  static Future<List<TWNetwork>> findAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.network.findAllItems();
    } catch (e) {
      debugPrint('TWNetworkHelper findAllItems error: $e');
      return [];
    }
  }

  /// find by id
  static Future<TWNetwork?> findItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      return db.network.findItemById(id);
    } catch (e) {
      debugPrint('TWNetworkHelper findItemById error: $e');
      return null;
    }
  }

  /// delete all
  static Future<void> deleteAllItems() async {
    try {
      final db = await TWDataBaseHelper.database();
      db.network.deleteAllItems();
    } catch (e) {
      debugPrint('TWNetworkHelper deleteAllItems error: $e');
    }
  }

  /// delete crash log by id
  static Future<void> deleteItemById(int id) async {
    try {
      final db = await TWDataBaseHelper.database();
      db.network.deleteItemById(id);
    } catch (e) {
      debugPrint('TWNetworkHelper deleteItemById error: $e');
    }
  }
}
