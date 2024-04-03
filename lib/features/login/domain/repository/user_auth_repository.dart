import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';

abstract class UserAuthRepository {
  Future<UserAuthEntity?> readByUsernameOrEmail(String identifier);
}
