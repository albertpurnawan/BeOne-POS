// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BatchInvoiceEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tinv1Docid;
  final String? toitmId;
  final String batchNo;

  BatchInvoiceEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tinv1Docid,
    required this.toitmId,
    required this.batchNo,
  });

  BatchInvoiceEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tinv1Docid,
    String? toitmId,
    String? batchNo,
  }) {
    return BatchInvoiceEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tinv1Docid: tinv1Docid ?? this.tinv1Docid,
      toitmId: toitmId ?? this.toitmId,
      batchNo: batchNo ?? this.batchNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tinv1Docid': tinv1Docid,
      'toitmId': toitmId,
      'batchNo': batchNo,
    };
  }

  factory BatchInvoiceEntity.fromMap(Map<String, dynamic> map) {
    return BatchInvoiceEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tinv1Docid:
          map['tinv1Docid'] != null ? map['tinv1Docid'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      batchNo: map['batchNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchInvoiceEntity.fromJson(String source) =>
      BatchInvoiceEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BatchInvoiceEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tinv1Docid: $tinv1Docid, toitmId: $toitmId, batchNo: $batchNo)';
  }

  @override
  bool operator ==(covariant BatchInvoiceEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tinv1Docid == tinv1Docid &&
        other.toitmId == toitmId &&
        other.batchNo == batchNo;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tinv1Docid.hashCode ^
        toitmId.hashCode ^
        batchNo.hashCode;
  }
}
