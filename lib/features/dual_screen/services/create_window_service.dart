import 'dart:convert';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_fe/features/dual_screen/data/models/send_data.dart';
import 'package:window_manager/window_manager.dart';

Future<bool> initWindow(final mounted, SendBaseData data) async {
  // Initialize the window
  if (!mounted) {
    return false;
  }

  try {
    // Create a new window

    windowManager.maximize().then((value) async {
      // Extract width and height
      final physicalSize = window.physicalSize;
      final maxWidth = physicalSize.width;
      final maxHeight = physicalSize.height;

      final newWindow = await DesktopMultiWindow.createWindow(jsonEncode(data.toMap()));
      newWindow
        ..setFrame(Rect.fromLTWH(100 * maxWidth, 0, maxWidth, maxHeight))
        ..center()
        ..show();
      await DesktopWindow.setFullScreen(true);
      await DesktopWindow.focus();
    });

    return true;
  } on Exception catch (e) {
    debugPrint('Error Create Window: $e');

    return false;
  }
}
