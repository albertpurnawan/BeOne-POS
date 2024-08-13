import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/settings/domain/usecases/encrypt.dart';

class GenerateDeviceNumberUseCase implements UseCase<void, void> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  Future<String> call({void params}) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final String deviceId = "${androidInfo.id}-${androidInfo.model}-${androidInfo.manufacturer}";
    final encrypt = GetIt.instance<EncryptPasswordUseCase>();
    final deviceEncrypt = await encrypt.call(params: deviceId);
    return deviceEncrypt;
  }
}
