import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/token_service.dart';
import 'package:pos_fe/features/settings/domain/usecases/decrypt.dart';
import 'package:pos_fe/features/settings/domain/usecases/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshTokenUseCase implements UseCase<void, String> {
  @override
  Future<void> call({String? params}) async {
    return _refreshToken();
  }

  Future<void> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final decryptPasswordUseCase = GetIt.instance<DecryptPasswordUseCase>();
    final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();

    final decryptPass = await decryptPasswordUseCase.call(params: topos[0].passwordAdmin);

    final token = await GetIt.instance<TokenApi>().getToken(topos[0].baseUrl!, topos[0].usernameAdmin!, decryptPass);

    final encryptPasswordUseCase = GetIt.instance<EncryptPasswordUseCase>();
    final encryptToken = await encryptPasswordUseCase.call(params: token);
    prefs.setString('adminToken', token!);
  }
}
