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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'email': email,
      'password': password,
    };
  }

  factory UserAuthEntity.fromMap(Map<String, dynamic> map) {
    return UserAuthEntity(
      docid: map['docid'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAuthEntity.fromJson(String source) =>
      UserAuthEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAuthEntity(docid: $docid, email: $email, password: $password)';
  }

  @override
  bool operator ==(covariant UserAuthEntity other) {
    if (identical(this, other)) return true;

    return other.docid == docid &&
        other.email == email &&
        other.password == password;
  }
}