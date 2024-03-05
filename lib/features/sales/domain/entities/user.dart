// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String email;
  final String username;
  final String password;
  final String? tohemId;
  final String? torolId;
  final int statusActive;
  final int activated;
  final int superUser;
  final int provider;
  final int? userType;
  final String? trolleyUser;
  final String? trolleyPass;

  UserEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.email,
    required this.username,
    required this.password,
    required this.tohemId,
    required this.torolId,
    required this.statusActive,
    required this.activated,
    required this.superUser,
    required this.provider,
    required this.userType,
    required this.trolleyUser,
    required this.trolleyPass,
  });

  UserEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? email,
    String? username,
    String? password,
    String? tohemId,
    String? torolId,
    int? statusActive,
    int? activated,
    int? superUser,
    int? provider,
    int? userType,
    String? trolleyUser,
    String? trolleyPass,
  }) {
    return UserEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      tohemId: tohemId ?? this.tohemId,
      torolId: torolId ?? this.torolId,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      superUser: superUser ?? this.superUser,
      provider: provider ?? this.provider,
      userType: userType ?? this.userType,
      trolleyUser: trolleyUser ?? this.trolleyUser,
      trolleyPass: trolleyPass ?? this.trolleyPass,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'email': email,
      'username': username,
      'password': password,
      'tohemId': tohemId,
      'torolId': torolId,
      'statusActive': statusActive,
      'activated': activated,
      'superUser': superUser,
      'provider': provider,
      'userType': userType,
      'trolleyUser': trolleyUser,
      'trolleyPass': trolleyPass,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      email: map['email'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      torolId: map['torolId'] != null ? map['torolId'] as String : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      superUser: map['superUser'] as int,
      provider: map['provider'] as int,
      userType: map['userType'] != null ? map['userType'] as int : null,
      trolleyUser:
          map['trolleyUser'] != null ? map['trolleyUser'] as String : null,
      trolleyPass:
          map['trolleyPass'] != null ? map['trolleyPass'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, email: $email, username: $username, password: $password, tohemId: $tohemId, torolId: $torolId, statusActive: $statusActive, activated: $activated, superUser: $superUser, provider: $provider, userType: $userType, trolleyUser: $trolleyUser, trolleyPass: $trolleyPass)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.email == email &&
        other.username == username &&
        other.password == password &&
        other.tohemId == tohemId &&
        other.torolId == torolId &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.superUser == superUser &&
        other.provider == provider &&
        other.userType == userType &&
        other.trolleyUser == trolleyUser &&
        other.trolleyPass == trolleyPass;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        email.hashCode ^
        username.hashCode ^
        password.hashCode ^
        tohemId.hashCode ^
        torolId.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        superUser.hashCode ^
        provider.hashCode ^
        userType.hashCode ^
        trolleyUser.hashCode ^
        trolleyPass.hashCode;
  }
}
