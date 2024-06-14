import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/repository/user_repository.dart';

class GetUserUseCase implements UseCase<UserEntity?, String?> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<UserEntity?> call({String? params}) async {
    if (params == null) return null;
    return await _userRepository.getUser(params);
  }
}
