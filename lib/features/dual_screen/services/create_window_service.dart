import 'dart:convert';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_fe/features/dual_screen/data/models/send_data.dart';

Future<bool> initWindow(final mounted, SendBaseData data) async {
  // Initialize the window
  if (!mounted) {
    return false;
  }

  try {
    // Create a new window

    final physicalSize = window.physicalSize;

    // Extract width and height
    final maxWidth = physicalSize.width;
    final maxHeight = physicalSize.height;

    final newWindow =
        await DesktopMultiWindow.createWindow(jsonEncode(data.toMap()));
    newWindow
      ..setFrame(
          Rect.fromLTWH(2 * maxWidth, 2 * maxHeight, maxWidth, maxHeight))
      ..center()
      ..show();
    return true;
  } on Exception catch (e) {
    debugPrint('Error Create Window: $e');

    return false;
  }
}
