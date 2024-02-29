import 'dart:convert';

class UserAuthModel {
  String? docid;
  String email;
  String? password;

  UserAuthModel(
      {required this.docid, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'email': email,
      'password': password,
    };
  }

  factory UserAuthModel.fromMap(Map<String, dynamic> map) {
    return UserAuthModel(
      docid: map['docid'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
