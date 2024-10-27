import 'package:logger/logger.dart';
import 'helper/tw_regular_helper.dart';
import 'tw_logger_configure.dart';

class TWConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final filterLogLines = TWLoggerConfigure().filterLogLines;
    for (var line in event.lines) {
      if (filterLogLines.contains(line)) {
        continue;
      }
      // ignore: avoid_print
      print(line);
    }
    TWRegularHelper.handleLogCache(event);
  }
}
