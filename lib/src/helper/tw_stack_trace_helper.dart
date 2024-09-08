class TWStackTraceHelper {
  /// Get the module of the stack trace
  static String getStackTraceInfo({
    StackTrace? stacktrace,
    String mark = '#1',
  }) {
    try {
      final tempStackTrace = stacktrace ?? StackTrace.current;
      var res = tempStackTrace.toString();
      const mark2 = '(';
      final index = res.indexOf(mark);
      if (index != -1) {
        final endIndex = res.indexOf(')', index);
        res = res.substring(index, endIndex);
      }
      final moduleIndex = res.indexOf('package:');
      if (moduleIndex != -1) {
        res = res.substring(moduleIndex);
      }
      res = res.replaceAll(mark, '');
      res = res.replaceAll(mark2, '');
      res = res.trim();
      return res;
    } catch (e) {
      return 'unknown';
    }
  }
}
