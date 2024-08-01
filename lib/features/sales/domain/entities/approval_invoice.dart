// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApprovalInvoiceEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toinvId;
  final String tousrId;
  final String remarks;
  final String category;

  ApprovalInvoiceEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toinvId,
    required this.tousrId,
    required this.remarks,
    required this.category,
  });

  ApprovalInvoiceEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvId,
    String? tousrId,
    String? remarks,
    String? category,
  }) {
    return ApprovalInvoiceEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvId: toinvId ?? this.toinvId,
      tousrId: tousrId ?? this.tousrId,
      remarks: remarks ?? this.remarks,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvId': toinvId,
      'tousrId': tousrId,
      'remarks': remarks,
      'category': category,
    };
  }

  factory ApprovalInvoiceEntity.fromMap(Map<String, dynamic> map) {
    return ApprovalInvoiceEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      tousrId: map['tousrId'] as String,
      remarks: map['remarks'] as String,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApprovalInvoiceEntity.fromJson(String source) =>
      ApprovalInvoiceEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApprovalInvoiceEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvId: $toinvId, tousrId: $tousrId, remarks: $remarks, category: $category)';
  }

  @override
  bool operator ==(covariant ApprovalInvoiceEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvId == toinvId &&
        other.tousrId == tousrId &&
        other.remarks == remarks &&
        other.category == category;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvId.hashCode ^
        tousrId.hashCode ^
        remarks.hashCode ^
        category.hashCode;
  }
}
