// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAuthEntity {
  String? docid;
  String email;
  String? password;

  UserAuthEntity({
    required this.docid,
    required this.email,
    required this.password,
  });

  UserAuthEntity copyWith({
    String? docid,
    String? email,
    String? password,
  }) {
    return UserAuthEntity(
      docid: docid ?? this.docid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'email': email,
      'password': password,
    };
  }

  factory UserAuthEntity.fromMap(Map<String, dynamic> map) {
    return UserAuthEntity(
      docid: map['docid'] != null ? map['docid'] as String : null,
      email: map['email'] as String,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAuthEntity.fromJson(String source) =>
      UserAuthEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserAuthEntity(docid: $docid, email: $email, password: $password)';

  @override
  bool operator ==(covariant UserAuthEntity other) {
    if (identical(this, other)) return true;

    return other.docid == docid &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => docid.hashCode ^ email.hashCode ^ password.hashCode;
}
