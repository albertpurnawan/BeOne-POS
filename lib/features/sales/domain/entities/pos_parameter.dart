import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class POSParameterEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? gtentId;
  final String? tostrId;
  final String? storeName;
  final String? tocsrId;
  final String? baseUrl;
  final String? usernameAdmin;
  final String? passwordAdmin;
  final String? lastSync;
  final int? defaultShowKeyboard;

  POSParameterEntity(
      {required this.docId,
      this.createDate,
      this.updateDate,
      this.gtentId,
      this.tostrId,
      this.storeName,
      this.tocsrId,
      this.baseUrl,
      this.usernameAdmin,
      this.passwordAdmin,
      this.lastSync,
      this.defaultShowKeyboard});

  POSParameterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? gtentId,
    String? tostrId,
    String? storeName,
    String? tocsrId,
    String? baseUrl,
    String? usernameAdmin,
    String? passwordAdmin,
    String? lastSync,
    int? defaultShowKeyboard,
  }) {
    return POSParameterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      gtentId: gtentId ?? this.gtentId,
      tostrId: tostrId ?? this.tostrId,
      storeName: storeName ?? this.storeName,
      tocsrId: tocsrId ?? this.tocsrId,
      baseUrl: baseUrl ?? this.baseUrl,
      usernameAdmin: usernameAdmin ?? this.usernameAdmin,
      passwordAdmin: passwordAdmin ?? this.passwordAdmin,
      lastSync: lastSync ?? this.lastSync,
      defaultShowKeyboard: defaultShowKeyboard ?? this.defaultShowKeyboard,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'gtentId': gtentId,
      'tostrId': tostrId,
      'storeName': storeName,
      'tocsrId': tocsrId,
      'baseUrl': baseUrl,
      'usernameAdmin': usernameAdmin,
      'passwordAdmin': passwordAdmin,
      'lastSync': lastSync,
      'defaultShowKeyboard': defaultShowKeyboard,
    };
  }

  factory POSParameterEntity.fromMap(Map<String, dynamic> map) {
    return POSParameterEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int) : null,
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      gtentId: map['gtentId'] != null ? map['gtentId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      storeName: map['storeName'] != null ? map['storeName'] as String : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      baseUrl: map['baseUrl'] != null ? map['baseUrl'] as String : null,
      usernameAdmin: map['usernameAdmin'] != null ? map['usernameAdmin'] as String : null,
      passwordAdmin: map['passwordAdmin'] != null ? map['passwordAdmin'] as String : null,
      lastSync: map['lastSync'] != null ? map['lastSync'] as String : null,
      defaultShowKeyboard: map['defaultShowKeyboard'] != null ? map['defaultShowKeyboard'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory POSParameterEntity.fromJson(String source) =>
      POSParameterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'POSParameterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, gtentId: $gtentId, tostrId: $tostrId, storeName: $storeName, tocsrId: $tocsrId, baseUrl: $baseUrl, usernameAdmin: $usernameAdmin, passwordAdmin: $passwordAdmin, lastSync: $lastSync, defaultShowKeyboard: $defaultShowKeyboard)';
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
        other.tocsrId == tocsrId &&
        other.baseUrl == baseUrl &&
        other.usernameAdmin == usernameAdmin &&
        other.passwordAdmin == passwordAdmin &&
        other.lastSync == lastSync &&
        other.defaultShowKeyboard == defaultShowKeyboard;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        gtentId.hashCode ^
        tostrId.hashCode ^
        storeName.hashCode ^
        tocsrId.hashCode ^
        baseUrl.hashCode ^
        usernameAdmin.hashCode ^
        passwordAdmin.hashCode ^
        lastSync.hashCode ^
        defaultShowKeyboard.hashCode;
  }
}
