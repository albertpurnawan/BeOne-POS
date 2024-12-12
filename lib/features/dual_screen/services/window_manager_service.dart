import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

class WindowManagerService {
  static const String HOME_WINDOW = 'home';
  static const String SALES_WINDOW = 'sales';
  static const String DUAL_SCREEN_WINDOW = 'dual_screen';

  // Map to track window instances by type
  final Map<String, int> _windowInstances = {};

  WindowManagerService._internal();

  // Check if a window of given type exists
  Future<bool> hasWindow(String windowType) async {
    try {
      final windows = await DesktopMultiWindow.getAllSubWindowIds();
    } catch (e) {
      createWindow;
    }
    return _windowInstances.containsKey(windowType);
  }

  // Focus existing window if it exists
  Future<bool> focusWindow(String windowType) async {
    if (await hasWindow(windowType)) {
      final windowId = _windowInstances[windowType];
      if (windowId != null) {
        final controller = await WindowController.fromWindowId(windowId);
        await controller.show();
        return true;
      }
    }
    return false;
  }

  // Create a new window if it doesn't exist
  Future<WindowController?> createWindow(
    String windowType, {
    required Map<String, dynamic> arguments,
    Size? size,
    Offset? position,
    String? title,
  }) async {
    // Check if window already exists
    if (await hasWindow(windowType)) {
      await focusWindow(windowType);
      return null;
    }

    // Create new window
    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      ...arguments,
      'windowType': windowType,
    }));

    // Set window properties
    if (size != null) {
      await window.setFrame(Offset.zero & size);
    }
    if (title != null) {
      await window.setTitle(title);
    }

    // Store window instance
    _windowInstances[windowType] = window.windowId;

    return window;
  }

  // Remove window from tracking when closed
  void removeWindow(String windowType) {
    _windowInstances.remove(windowType);
  }

  // Get all active windows
  Future<List<int>> getAllWindows() async {
    return await DesktopMultiWindow.getAllSubWindowIds();
  }
}
