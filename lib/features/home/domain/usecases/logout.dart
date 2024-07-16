import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutUseCase implements UseCase<void, void> {
  final SharedPreferences _prefs;

  LogoutUseCase(this._prefs);

  @override
  Future<void> call({void params}) async {
    // log("${_prefs.getBool("logStatus")}");
    await _prefs.setBool("logStatus", false);
    await _prefs.remove("username");
    await _prefs.remove("email");
    await _prefs.remove("tohemId");
    await _prefs.remove("torolId");
  }
}
