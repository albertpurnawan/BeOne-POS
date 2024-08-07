// import 'dart:developer';

// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FirstRunManager {
//   static const String firstRunKey = "firstRun";

//   static Future<void> checkFirstRun() async {
//     final prefs = GetIt.instance<SharedPreferences>();
//     bool isFirstRun = prefs.getBool(firstRunKey) ?? true;

//     if (isFirstRun) {
//       await prefs.clear();
//     }

//     await prefs.setBool(firstRunKey, false);

//     log("FirstRun - $isFirstRun");
//   }
// }
