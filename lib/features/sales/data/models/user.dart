import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';

const String tableUser = "tousr";

class UserFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    email,
    username,
    password,
    tohemId,
    torolId,
    statusActive,
    activated,
    superUser,
    provider,
    userType,
    trolleyUser,
    trolleyPass,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String email = "email";
  static const String username = "username";
  static const String password = "password";
  static const String tohemId = "tohemId";
  static const String torolId = "torolId";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String superUser = "superuser";
  static const String provider = "provider";
  static const String userType = "usertype";
  static const String trolleyUser = "trolleyuser";
  static const String trolleyPass = "trolleypass";
}

class UserModel extends UserEntity implements BaseModel {
  UserModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.email,
    required super.username,
    required super.password,
    required super.tohemId,
    required super.torolId,
    required super.statusActive,
    required super.activated,
    required super.superUser,
    required super.provider,
    required super.userType,
    required super.trolleyUser,
    required super.trolleyPass,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'email': email,
      'username': username,
      'password': password,
      'tohemId': tohemId,
      'torolId': torolId,
      'statusactive': statusActive,
      'activated': activated,
      'superuser': superUser,
      'provider': provider,
      'usertype': userType,
      'trolleyuser': trolleyUser,
      'trolleypass': trolleyPass,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      email: map['email'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      torolId: map['torolId'] != null ? map['torolId'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      superUser: map['superuser'] as int,
      provider: map['provider'] as int,
      userType: map['usertype'] != null ? map['usertype'] as int : null,
      trolleyUser:
          map['trolleyuser'] != null ? map['trolleyuser'] as String : null,
      trolleyPass:
          map['trolleypass'] != null ? map['trolleypass'] as String : null,
    );
  }

  factory UserModel.fromMapRemote(Map<String, dynamic> map) {
    return UserModel.fromMap({
      ...map,
      "tohemId": map['tohem_id']?['docid'] != null
          ? map['tohem_id']['docid'] as String
          : null,
      "torolId": map['torol_id']?['docid'] != null
          ? map['torol_id']['docid'] as String
          : null,
    });
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      tohemId: entity.tohemId,
      torolId: entity.torolId,
      statusActive: entity.statusActive,
      activated: entity.activated,
      superUser: entity.superUser,
      provider: entity.provider,
      userType: entity.userType,
      trolleyUser: entity.trolleyUser,
      trolleyPass: entity.trolleyPass,
    );
  }
}
