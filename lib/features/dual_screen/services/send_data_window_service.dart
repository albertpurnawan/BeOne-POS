import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

Future<bool> sendData(
    final windowId, final jsonData, final method, final from) async {
  try {
    final result =
        await DesktopMultiWindow.invokeMethod(windowId, method, jsonData);
    if (result != null && result is bool && result) {
      return true;
    }
  } catch (e) {
    debugPrint('Error send data to client display from $from: $e');
  }
  return false;
}
