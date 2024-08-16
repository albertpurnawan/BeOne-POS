import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_fe/core/usecases/usecase.dart';

class GetAppVersionUseCase implements UseCase<AppVersionInfo, void> {
  @override
  Future<AppVersionInfo> call({void params}) async {
    final packageInfo = await PackageInfo.fromPlatform();

    // Get the version and build number
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    // Return the version info
    return AppVersionInfo(
      version: version,
      buildNumber: buildNumber,
    );
  }
}

class AppVersionInfo {
  final String version;
  final String buildNumber;

  AppVersionInfo({
    required this.version,
    required this.buildNumber,
  });
}
