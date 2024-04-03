import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/login/data/models/user_auth_model.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/repository/user_auth_repository.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final AppDatabase _appDatabase;
  UserAuthRepositoryImpl(this._appDatabase);

  @override
  Future<UserAuthEntity?> readByUsernameOrEmail(String identifier) async {
    // TODO: implement readByUsernameOrEmail
    return _appDatabase.userAuthDao.readByUsernameOrEmail(identifier);
  }
}
