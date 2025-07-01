import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:tw_logger/tw_logger.dart';

typedef TWLogFilterHandler = bool Function(
  TWLogLevel? level,
  dynamic message,
  Object? error,
  StackTrace? stackTrace,
  DateTime time,
);

class TWLogFilter extends LogFilter {
  TWLogFilterHandler? filterHandler;
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode) {
      return false;
    }
    if (filterHandler != null) {
      return !filterHandler!(
        TWLogLevel.fromLevel(event.level),
        event.message,
        event.error,
        event.stackTrace,
        event.time,
      );
    }
    return true;
  }
}
