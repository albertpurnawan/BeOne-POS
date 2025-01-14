import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/usecase.dart';

class EncryptPasswordUseCase implements UseCase<String, String> {
  final String _key = Constant.secretkey;

  @override
  Future<String> call({String? params}) async {
    if (params == null) {
      throw ArgumentError('Password cannot be null');
    }
    return _encryptPassword(params);
  }

  Future<String> _encryptPassword(String password) async {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(password, iv: iv);
    return iv.base64 + encrypted.base64;
  }
}
