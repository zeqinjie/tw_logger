import 'package:logger/logger.dart';
import 'package:tw_logger/src/tw_console_output.dart';
import 'package:tw_logger/src/tw_log_filter.dart';

enum TWLogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal;

  static Map<TWLogLevel, Level> _map = {
    TWLogLevel.trace: Level.trace,
    TWLogLevel.debug: Level.debug,
    TWLogLevel.info: Level.info,
    TWLogLevel.warning: Level.warning,
    TWLogLevel.error: Level.error,
    TWLogLevel.fatal: Level.fatal,
  };

  Level get _level {
    return _map[this] ?? Level.info;
  }

  int? get value {
    return _map[this]?.value;
  }

  static TWLogLevel? fromLevel(Level level) {
    return _map.entries
        .firstWhere(
          (element) => element.value == level,
          orElse: () => const MapEntry(TWLogLevel.info, Level.info),
        )
        .key;
  }

  static String name(int value) {
    return _map.entries
        .firstWhere(
          (element) => element.value.value == value,
          orElse: () => const MapEntry(TWLogLevel.info, Level.info),
        )
        .value
        .toString();
  }
}

class TWLogger {
  static final TWLogger _instance = TWLogger._internal();
  factory TWLogger() => _instance;
  TWLogger._internal();

  final _filter = TWLogFilter();

  late final Logger _logger = Logger(
    output: TWConsoleOutput(),
    filter: _filter,
  );

  set level(TWLogLevel level) {
    Logger.level = level._level;
  }

  set filter(TWLogFilterHandler handler) {
    _filter.filterHandler = handler;
  }

  static void log(
    dynamic message, {
    TWLogLevel level = TWLogLevel.debug,
    DateTime? time,
    Object? error,
  }) {
    TWLogger()._logger.log(
          level._level,
          message,
          time: time,
          error: error,
          stackTrace: StackTrace.current,
        );
  }
}
