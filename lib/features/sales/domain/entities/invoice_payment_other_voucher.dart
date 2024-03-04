// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IPOVEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toinvId;
  final int type;
  final String serialNo;
  final double amount;

  IPOVEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toinvId,
    required this.type,
    required this.serialNo,
    required this.amount,
  });

  IPOVEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvId,
    int? type,
    String? serialNo,
    double? amount,
  }) {
    return IPOVEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvId: toinvId ?? this.toinvId,
      type: type ?? this.type,
      serialNo: serialNo ?? this.serialNo,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvId': toinvId,
      'type': type,
      'serialNo': serialNo,
      'amount': amount,
    };
  }

  factory IPOVEntity.fromMap(Map<String, dynamic> map) {
    return IPOVEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      type: map['type'] as int,
      serialNo: map['serialNo'] as String,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory IPOVEntity.fromJson(String source) =>
      IPOVEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IPOVEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvId: $toinvId, type: $type, serialNo: $serialNo, amount: $amount)';
  }

  @override
  bool operator ==(covariant IPOVEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvId == toinvId &&
        other.type == type &&
        other.serialNo == serialNo &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvId.hashCode ^
        type.hashCode ^
        serialNo.hashCode ^
        amount.hashCode;
  }
}
