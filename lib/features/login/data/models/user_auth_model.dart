import 'dart:convert';

import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';

class UserAuthModel extends UserAuthEntity implements BaseModel {
  UserAuthModel({
    required super.docId,
    required super.email,
    required super.username,
    required super.password,
    required super.tohemId,
    required super.torolId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'email': email,
      'username': username,
      'password': password,
      'tohemId': tohemId,
      'torolId': torolId,
    };
  }

  factory UserAuthModel.fromMap(Map<String, dynamic> map) {
    return UserAuthModel(
      docId: map['docId'] != null ? map['docId'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      torolId: map['torolId'] != null ? map['torolId'] as String : null,
    );
  }
}
