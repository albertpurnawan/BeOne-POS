// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class ConnectivityService extends ChangeNotifier {
//   bool _isConnected = true;
//   bool get isConnected => _isConnected;

//   Future<void> init() async {
//     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
//       _isConnected = result.isNotEmpty && result[0] != ConnectivityResult.none;
//       notifyListeners();
//     });
//   }
// }
