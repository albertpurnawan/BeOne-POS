import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/usecase.dart';

class DecryptUseCase implements UseCase<String, String> {
  final String _key = Constant.secretkey;

  @override
  Future<String> call({String? params}) async {
    if (params == null) {
      throw ArgumentError('Password cannot be null');
    }
    return _decryptPassword(params);
  }

  Future<String> _decryptPassword(String encryptedData) async {
    final key = encrypt.Key.fromUtf8(_key);

    final ivBase64 = encryptedData.substring(0, 24);
    final encryptedPasswordBase64 = encryptedData.substring(24);

    final iv = encrypt.IV.fromBase64(ivBase64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedPasswordBase64, iv: iv);
    return decrypted;
  }
}
