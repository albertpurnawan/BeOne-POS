import 'package:pos_fe/features/sales/domain/entities/user.dart';

abstract class UserRepository {
  Future<UserEntity?> getUsername(String username);
}
