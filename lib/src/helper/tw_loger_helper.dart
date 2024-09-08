import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
}
