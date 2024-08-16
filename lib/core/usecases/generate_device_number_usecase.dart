import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/settings/domain/usecases/encrypt.dart';

class GenerateDeviceNumberUseCase implements UseCase<void, void> {
  final DeviceInfoPlugin deviceInfo;
  final EncryptPasswordUseCase _encryptPasswordUseCase;

  GenerateDeviceNumberUseCase(this.deviceInfo, this._encryptPasswordUseCase);

  @override
  Future<String> call({void params}) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final String deviceId = "${androidInfo.id}-${androidInfo.model}-${androidInfo.manufacturer}";
      final deviceEncrypt = await _encryptPasswordUseCase.call(params: deviceId);
      // return deviceEncrypt;
      return jsonEncode(androidInfo.data);
    } else {
      WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
      // log(jsonEncode(windowsDeviceInfo.data));
      final deviceEncrypt = await _encryptPasswordUseCase.call(params: windowsDeviceInfo.deviceId);
      return jsonEncode(windowsDeviceInfo.data);
    }
  }
}
