// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BatchCreditMemoEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? trin1Docid;
  final String? toitmId;
  final String batchNo;

  BatchCreditMemoEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.trin1Docid,
    required this.toitmId,
    required this.batchNo,
  });

  BatchCreditMemoEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? trin1Docid,
    String? toitmId,
    String? batchNo,
  }) {
    return BatchCreditMemoEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      trin1Docid: trin1Docid ?? this.trin1Docid,
      toitmId: toitmId ?? this.toitmId,
      batchNo: batchNo ?? this.batchNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'trin1Docid': trin1Docid,
      'toitmId': toitmId,
      'batchNo': batchNo,
    };
  }

  factory BatchCreditMemoEntity.fromMap(Map<String, dynamic> map) {
    return BatchCreditMemoEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      trin1Docid:
          map['trin1Docid'] != null ? map['trin1Docid'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      batchNo: map['batchNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchCreditMemoEntity.fromJson(String source) =>
      BatchCreditMemoEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BatchCreditMemoEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, trin1Docid: $trin1Docid, toitmId: $toitmId, batchNo: $batchNo)';
  }

  @override
  bool operator ==(covariant BatchCreditMemoEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.trin1Docid == trin1Docid &&
        other.toitmId == toitmId &&
        other.batchNo == batchNo;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        trin1Docid.hashCode ^
        toitmId.hashCode ^
        batchNo.hashCode;
  }
}
