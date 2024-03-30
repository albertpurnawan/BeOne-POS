// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class POSParameterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? gtentId;
  final String? tostrId;
  final String storeName;
  final String? tcurrId;
  final String currCode;
  final String? tocsrId;
  final String? tovatId;
  final String? baseUrl;
  final String? user;
  final String? password;

  POSParameterEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.gtentId,
    required this.tostrId,
    required this.storeName,
    required this.tcurrId,
    required this.currCode,
    required this.tocsrId,
    required this.tovatId,
    required this.baseUrl,
    required this.user,
    required this.password,
  });

  POSParameterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? gtentId,
    String? tostrId,
    String? storeName,
    String? tcurrId,
    String? currCode,
    String? tocsrId,
    String? tovatId,
    String? baseUrl,
    String? user,
    String? password,
  }) {
    return POSParameterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      gtentId: gtentId ?? this.gtentId,
      tostrId: tostrId ?? this.tostrId,
      storeName: storeName ?? this.storeName,
      tcurrId: tcurrId ?? this.tcurrId,
      currCode: currCode ?? this.currCode,
      tocsrId: tocsrId ?? this.tocsrId,
      tovatId: tovatId ?? this.tovatId,
      baseUrl: baseUrl ?? this.baseUrl,
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'gtentId': gtentId,
      'tostrId': tostrId,
      'storeName': storeName,
      'tcurrId': tcurrId,
      'currCode': currCode,
      'tocsrId': tocsrId,
      'tovatId': tovatId,
      'baseUrl': baseUrl,
      'user': user,
      'password': password,
    };
  }

  factory POSParameterEntity.fromMap(Map<String, dynamic> map) {
    return POSParameterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      gtentId: map['gtentId'] != null ? map['gtentId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      storeName: map['storeName'] as String,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      currCode: map['currCode'] as String,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      baseUrl: map['baseUrl'] != null ? map['baseUrl'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory POSParameterEntity.fromJson(String source) =>
      POSParameterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'POSParameterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, gtentId: $gtentId, tostrId: $tostrId, storeName: $storeName, tcurrId: $tcurrId, currCode: $currCode, tocsrId: $tocsrId, tovatId: $tovatId, baseUrl: $baseUrl, user: $user, password: $password)';
  }

  @override
  bool operator ==(covariant POSParameterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.gtentId == gtentId &&
        other.tostrId == tostrId &&
        other.storeName == storeName &&
        other.tcurrId == tcurrId &&
        other.currCode == currCode &&
        other.tocsrId == tocsrId &&
        other.tovatId == tovatId &&
        other.baseUrl == baseUrl &&
        other.user == user &&
        other.password == password;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        gtentId.hashCode ^
        tostrId.hashCode ^
        storeName.hashCode ^
        tcurrId.hashCode ^
        currCode.hashCode ^
        tocsrId.hashCode ^
        tovatId.hashCode ^
        baseUrl.hashCode ^
        user.hashCode ^
        password.hashCode;
  }
}
