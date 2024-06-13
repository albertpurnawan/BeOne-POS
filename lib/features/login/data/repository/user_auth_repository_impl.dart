import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/repository/user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final AppDatabase _appDatabase;
  UserAuthRepositoryImpl(this._appDatabase);

  @override
  Future<UserAuthEntity?> readByUsernameOrEmail(String identifier) async {
    return _appDatabase.userAuthDao.readByUsernameOrEmail(identifier);
  }
}
