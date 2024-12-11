import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';

Future<bool> sendData(
    final windowId, final jsonData, final method, final from) async {
  try {
    if (await GetIt.instance<GetPosParameterUseCase>().call() != null &&
        (await GetIt.instance<GetPosParameterUseCase>().call())!
                .customerDisplayActive ==
            0) {
      return false;
    }
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
