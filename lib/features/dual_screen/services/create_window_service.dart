import 'dart:convert';

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

    final window =
        await DesktopMultiWindow.createWindow(jsonEncode(data.toMap()));
    window
      ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle('Customer window')
      ..show();
    return true;
  } on Exception catch (e) {
    debugPrint('Error Create Window: $e');

    return false;
  }
}
