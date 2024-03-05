// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HouseBankAccountEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String accountNo;
  final String accountName;
  final String bank;
  final String? tostrId;

  HouseBankAccountEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.accountNo,
    required this.accountName,
    required this.bank,
    required this.tostrId,
  });

  HouseBankAccountEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? accountNo,
    String? accountName,
    String? bank,
    String? tostrId,
  }) {
    return HouseBankAccountEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      accountNo: accountNo ?? this.accountNo,
      accountName: accountName ?? this.accountName,
      bank: bank ?? this.bank,
      tostrId: tostrId ?? this.tostrId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'accountNo': accountNo,
      'accountName': accountName,
      'bank': bank,
      'tostrId': tostrId,
    };
  }

  factory HouseBankAccountEntity.fromMap(Map<String, dynamic> map) {
    return HouseBankAccountEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      accountNo: map['accountNo'] as String,
      accountName: map['accountName'] as String,
      bank: map['bank'] as String,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseBankAccountEntity.fromJson(String source) =>
      HouseBankAccountEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HouseBankAccountEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, accountNo: $accountNo, accountName: $accountName, bank: $bank, tostrId: $tostrId)';
  }

  @override
  bool operator ==(covariant HouseBankAccountEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.accountNo == accountNo &&
        other.accountName == accountName &&
        other.bank == bank &&
        other.tostrId == tostrId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        accountNo.hashCode ^
        accountName.hashCode ^
        bank.hashCode ^
        tostrId.hashCode;
  }
}
