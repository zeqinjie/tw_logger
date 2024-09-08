import 'package:flutter_test/flutter_test.dart';

import 'package:tw_logger/tw_logger.dart';

void main() {
  group('group name', () {
    test('test TWLogger', () {
      TWLogger.log('test trace', level: TWLogLevel.trace);
      TWLogger.log('test debug', level: TWLogLevel.debug);
      TWLogger.log('test warning', level: TWLogLevel.warning);
      TWLogger.log('test info', level: TWLogLevel.info);
      TWLogger.log('test error', level: TWLogLevel.error);
      TWLogger.log('test fatal', level: TWLogLevel.fatal);
    });

    test(
      'test long info',
      () {
        TWLogger.log('test long info' * 1000, level: TWLogLevel.info);
      },
    );
  });
}
