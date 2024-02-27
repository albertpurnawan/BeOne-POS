class UsersModel {
  // final int? id;
  final String docid;
  final DateTime createdate;
  final DateTime? updatedate;
  final int? gtentId;
  final String email;
  final String username;
  final String password;
  final int? tohemId;
  final int? torolId;
  final int statusactive;
  final int activated;
  final int superuser;
  final int provider;
  final int? usertype;
  final String? trolleyuser;

  UsersModel(
      {required this.docid,
      required this.createdate,
      this.updatedate,
      this.gtentId,
      required this.email,
      required this.username,
      required this.password,
      this.tohemId,
      this.torolId,
      required this.statusactive,
      required this.activated,
      required this.superuser,
      required this.provider,
      this.usertype,
      this.trolleyuser});

  @override
  String toString() {
    return '''UsersModel{
      docid: $docid,
      createdate: $createdate,
      updatedate: $updatedate,
      gtentId: $gtentId,
      email: $email,
      username: $username,
      password: $password,
      tohemId: $tohemId,
      torolId: $torolId,
      statusactive: $statusactive,
      activated: $activated,
      superuser: $superuser,
      provider: $provider,
      usertype: $usertype,
      trolleyuser: $trolleyuser,
      }''';
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      docid: json['docid'],
      createdate: DateTime.parse(json['createdate']),
      updatedate: DateTime.parse(json['updatedate']),
      gtentId: json['gtentId'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      tohemId: json['tohemId'],
      torolId: json['torolId'],
      statusactive: json['statusactive'],
      activated: json['activated'],
      superuser: json['superuser'],
      provider: json['provider'],
      usertype: json['usertype'],
      trolleyuser: json['trolleyuser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docid': docid,
      'createdate': createdate.toIso8601String(),
      'updatedate': updatedate?.toIso8601String(),
      'gtentId': gtentId,
      'email': email,
      'username': username,
      'password': password,
      'tohemId': tohemId,
      'torolId': torolId,
      'statusactive': statusactive,
      'activated': activated,
      'superuser': superuser,
      'provider': provider,
      'usertype': usertype,
      'trolleyuser': trolleyuser,
    };
  }
}
