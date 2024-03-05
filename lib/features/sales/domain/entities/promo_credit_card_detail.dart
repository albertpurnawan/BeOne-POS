// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCreditCardDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprcId;
  final String? tpmt2Id;

  PromoCreditCardDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprcId,
    required this.tpmt2Id,
  });

  PromoCreditCardDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprcId,
    String? tpmt2Id,
  }) {
    return PromoCreditCardDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprcId: toprcId ?? this.toprcId,
      tpmt2Id: tpmt2Id ?? this.tpmt2Id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprcId': toprcId,
      'tpmt2Id': tpmt2Id,
    };
  }

  factory PromoCreditCardDetailEntity.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCreditCardDetailEntity.fromJson(String source) =>
      PromoCreditCardDetailEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCreditCardDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprcId: $toprcId, tpmt2Id: $tpmt2Id)';
  }

  @override
  bool operator ==(covariant PromoCreditCardDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprcId == toprcId &&
        other.tpmt2Id == tpmt2Id;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprcId.hashCode ^
        tpmt2Id.hashCode;
  }
}
