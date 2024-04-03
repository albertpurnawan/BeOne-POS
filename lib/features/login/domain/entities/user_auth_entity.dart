// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAuthEntity {
  String? docId;
  String? email;
  String? username;
  String? password;
  String? tohemId;
  String? torolId;

  UserAuthEntity({
    required this.docId,
    required this.email,
    required this.username,
    required this.password,
    required this.tohemId,
    required this.torolId,
  });

  UserAuthEntity copyWith({
    String? docId,
    String? email,
    String? username,
    String? password,
    String? tohemId,
    String? torolId,
  }) {
    return UserAuthEntity(
      docId: docId ?? this.docId,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      tohemId: tohemId ?? this.tohemId,
      torolId: torolId ?? this.torolId,
    );
  }

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

  factory UserAuthEntity.fromMap(Map<String, dynamic> map) {
    return UserAuthEntity(
      docId: map['docId'] != null ? map['docId'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      torolId: map['torolId'] != null ? map['torolId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAuthEntity.fromJson(String source) =>
      UserAuthEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAuthEntity(docId: $docId, email: $email, username: $username, password: $password, tohemId: $tohemId, torolId: $torolId)';
  }

  @override
  bool operator ==(covariant UserAuthEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.email == email &&
        other.username == username &&
        other.password == password &&
        other.tohemId == tohemId &&
        other.torolId == torolId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        email.hashCode ^
        username.hashCode ^
        password.hashCode ^
        tohemId.hashCode ^
        torolId.hashCode;
  }
}
