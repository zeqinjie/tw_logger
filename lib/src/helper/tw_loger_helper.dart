import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class TWLoggerHelper {
  /// copy to clipboard
  static void clipboard(
    BuildContext context,
    String? value,
  ) {
    Clipboard.setData(ClipboardData(text: value ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String formatter({
    required DateTime dateTime,
    String format = 'yyyy-MM-dd',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
