import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final AppDatabase _appDatabase;
  UserRepositoryImpl(this._appDatabase);

  @override
  Future<UserEntity?> getUsername(String username) {
    // TODO: implement getEmployee
    return _appDatabase.userDao.readByDocId(username);
  }
}
