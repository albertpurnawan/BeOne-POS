// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MOPAdjustmentDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tmpadId;
  final String? tpmt1Id;
  final double amount;
  final String? tpmt3Id;

  MOPAdjustmentDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tmpadId,
    required this.tpmt1Id,
    required this.amount,
    required this.tpmt3Id,
  });

  MOPAdjustmentDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tmpadId,
    String? tpmt1Id,
    double? amount,
    String? tpmt3Id,
  }) {
    return MOPAdjustmentDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tmpadId: tmpadId ?? this.tmpadId,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      amount: amount ?? this.amount,
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tmpadId': tmpadId,
      'tpmt1Id': tpmt1Id,
      'amount': amount,
      'tpmt3Id': tpmt3Id,
    };
  }

  factory MOPAdjustmentDetailEntity.fromMap(Map<String, dynamic> map) {
    return MOPAdjustmentDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tmpadId: map['tmpadId'] != null ? map['tmpadId'] as String : null,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      amount: map['amount'] as double,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MOPAdjustmentDetailEntity.fromJson(String source) =>
      MOPAdjustmentDetailEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MOPAdjustmentDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tmpadId: $tmpadId, tpmt1Id: $tpmt1Id, amount: $amount, tpmt3Id: $tpmt3Id)';
  }

  @override
  bool operator ==(covariant MOPAdjustmentDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tmpadId == tmpadId &&
        other.tpmt1Id == tpmt1Id &&
        other.amount == amount &&
        other.tpmt3Id == tpmt3Id;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tmpadId.hashCode ^
        tpmt1Id.hashCode ^
        amount.hashCode ^
        tpmt3Id.hashCode;
  }
}
