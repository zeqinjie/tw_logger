import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TWLoggerConfigure {
  // Singleton
  static final TWLoggerConfigure _instance = TWLoggerConfigure._internal();
  factory TWLoggerConfigure() => _instance;
  TWLoggerConfigure._internal();

  /// Whether to open logger overlay and cache database
  /// Default is true except for release mode
  bool isEnabled = true;

  /// Whether effect by release mode
  bool effectByReleaseMode = true;

  /// Timer to update cache database
  /// Default is 1 second
  Duration updateDuration = const Duration(seconds: 1);

  /// Whether to update cache database
  bool isUpdateDatabase = false;

  Color themeColor = Colors.deepPurple;

  /// filter log lines
  List<String> filterLogLines = <String>[
    '#0   TWLogger.log (package:tw_logger/src/tw_logger.dart:81:34)'
  ];

  bool get open {
    return isEnabled && (effectByReleaseMode && !kReleaseMode);
  }
}

class TWLoggerOverlayConfigure {
  static const double _defaultPadding = 30;
  final double bottom;
  final double right;
  final bool draggable;

  TWLoggerOverlayConfigure.optional({
    this.bottom = _defaultPadding,
    this.right = _defaultPadding,
    this.draggable = true,
  });
}
