import 'package:logger/logger.dart';
import 'helper/tw_regular_helper.dart';

class TWConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      // ignore: avoid_print
      print(line);
    }
    TWRegularHelper.handleLogCache(event);
  }
}
