import 'package:get_it/get_it.dart';
import 'package:pos_fe/features/dual_screen/services/window_manager_service.dart';

class WindowManagerProvider {
  static void register() {
    if (!GetIt.instance.isRegistered<WindowManagerService>()) {
      GetIt.instance
          .registerSingleton<WindowManagerService>(WindowManagerService());
    }
  }

  static WindowManagerService get service =>
      GetIt.instance<WindowManagerService>();
}
