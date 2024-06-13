import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  static BuildContext? get context =>
      GetIt.instance<GoRouter>().routerDelegate.navigatorKey.currentContext;

  static Future<void> go(String path) async {
    try {
      var context = NavigationHelper.context;
      if (context != null) {
        if (context.mounted) {
          return context.go(path);
        }
      } else {
        int maxRetryCount = 5;
        while ((await Future.delayed(const Duration(seconds: 1))) == null &&
            maxRetryCount != 1) {
          if (context != null) {
            if (context.mounted) {
              return context.go(path);
            }
          }
          maxRetryCount -= 1;
        }
      }

      return;
    } catch (e) {
      log("[ERROR] at NavigationHelper: $e");
    }
  }
}
